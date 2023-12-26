defmodule Puzzle04_1 do
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
      solve_for_card(winning_numbers, numbers_you_have)
    end |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

  defp solve_for_card(winning_numbers, numbers_you_have) do
    matching_numbers_nb = Enum.reduce(winning_numbers, 0, fn winning_number, acc ->
      if Enum.member?(numbers_you_have, winning_number) do
        acc + 1
      else
        acc
      end
    end)

    calculate_points(matching_numbers_nb)
  end

  defp calculate_points(0) do
    0
  end

  defp calculate_points(n) do
    2 ** (n - 1)
  end
end

IO.puts(Puzzle04_1.solve())
