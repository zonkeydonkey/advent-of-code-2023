defmodule EngineSpec do
  defstruct content: nil, size: 0
end

defmodule Puzzle03_1 do
  @input_file_path "priv/puzzle_03_input.txt"
  @symbols "!@#$%^&*()+-=~/"
  @symbols_with_dot "!@#$%^&*()+-=~/."
  @nb_elems_in_row 140

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(String.replace(file_content, "\n", ""))
  end

  defp solve(input) do
    input_chars = String.graphemes(input)
    solve(%EngineSpec{content: input_chars, size: length(input_chars)}, input_chars, [], false, 0, 0)
  end

  defp solve(input, [head | tail ], number_digits_acc, number_adjacent_acc?, sum_acc, index) do
    if String.contains?(@symbols_with_dot, head) do
      new_sum_acc = sum_acc + add_number_if_adjacent(number_digits_acc, number_adjacent_acc?)
      solve(input, tail, [], false, new_sum_acc, index + 1)
    else
      solve(input, tail, [head | number_digits_acc], number_adjacent_acc? || adjacent?(input, index), sum_acc, index + 1)
    end
  end

  defp solve(_, [], number_digits_acc, number_adjacent_acc?, sum_acc, _) do
    sum_acc + add_number_if_adjacent(number_digits_acc, number_adjacent_acc?)
  end

  defp add_number_if_adjacent(number_digits, number_adjacent_acc?) do
    if number_adjacent_acc? do
      add_number(number_digits, 1, 0)
    else
      0
    end
  end

  defp add_number([head | tail], multiplier, acc) do
    {num, _} = Integer.parse(head)
    add_number(tail, multiplier * 10, num * multiplier + acc)
  end

  defp add_number([], _, acc) do
    acc
  end

  defp adjacent?(input, index) do
    top_left_index = index - @nb_elems_in_row - 1
    top_index = index - @nb_elems_in_row
    top_right_index = index - @nb_elems_in_row + 1
    left_index = index - 1
    right_index = index + 1
    bottom_left_index = index + @nb_elems_in_row - 1
    bottom_index = index + @nb_elems_in_row
    bottom_right_index = index + @nb_elems_in_row + 1

    top_left = symbol?(input, top_left_index)
    top = symbol?(input, top_index)
    top_right = symbol?(input, top_right_index)
    left = symbol?(input, left_index)
    right = symbol?(input, right_index)
    bottom_left = symbol?(input, bottom_left_index)
    bottom = symbol?(input, bottom_index)
    bottom_right = symbol?(input, bottom_right_index)

    top_left || top || top_right || left || right || bottom_left || bottom || bottom_right
  end

  defp symbol?(input, index) do
    if index > -1 && index < input.size do
      String.contains?(@symbols, Enum.at(input.content, index))
    else
      false
    end
  end

end

IO.puts(Puzzle03_1.solve())
