defmodule Puzzle04_2 do
  @input_file_path "priv/puzzle_04_input.txt"

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(file_content)
  end

  defp solve(input) do
    for card_info <- String.split(input, ["\n"], trim: true),
      [winning_numbers_info, numbers_you_have_str] = String.split(card_info, ["|"], trim: true),
      [_, winning_numbers_str] = String.split(winning_numbers_info, [":"]),
      winning_numbers = String.split(winning_numbers_str, [" "], trim: true),
      numbers_you_have = String.split(numbers_you_have_str, [" "], trim: true) do
      get_matches_nb(winning_numbers, numbers_you_have)
    end |>
    calculate_scratchcards_nb() |>
    Enum.reduce(0, fn {_, x}, acc -> x + acc end)
  end

  defp get_matches_nb(winning_numbers, numbers_you_have) do
    Enum.reduce(winning_numbers, 0, fn winning_number, acc ->
      if Enum.member?(numbers_you_have, winning_number) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp calculate_scratchcards_nb(matches_nb_for_cards) do
    cards_nb = length(matches_nb_for_cards)
    calculate_scratchcards_nb(matches_nb_for_cards, replicate_index_to_1(cards_nb), 0)
  end

  defp calculate_scratchcards_nb([head | tail], acc, current_index) do
    current_scratchcard_nb = acc[current_index]
    case head do
      0 -> calculate_scratchcards_nb(tail, acc, current_index + 1)
      _ -> calculate_scratchcards_nb(tail, add_scratchcards(current_scratchcard_nb, head, acc, current_index), current_index + 1)
    end
  end

  defp calculate_scratchcards_nb([], acc, _) do
    acc
  end

  defp replicate_index_to_1(n), do: Enum.reduce(0..n-1, %{}, fn i, acc -> Map.put(acc, i, 1) end)

  defp add_scratchcards(current_scratchcard_nb, current_scratchcard_matching_nb, scratchcards_nb_acc, current_index) do
    Enum.reduce((current_index + 1)..(current_index + current_scratchcard_matching_nb), scratchcards_nb_acc, fn index, acc ->
      Map.put(acc, index, acc[index] + current_scratchcard_nb)
    end)
  end

end

IO.puts(Puzzle04_2.solve())
