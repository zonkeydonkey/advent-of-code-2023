defmodule EngineSpec do
  defstruct content: nil, size: 0
end

defmodule Puzzle03_2 do
  @input_file_path "priv/puzzle_03_input.txt"
  @digits "0123456789"
  @nb_elems_in_row 140

  @typedoc "A map mapping indexes of '*'' symbols to the list of numbers adjacent to that '*' in the engine specification"
  @type stars_spec() :: %{Integer.t() => [Integer.t()]}

  def solve() do
    file_content = File.read!(@input_file_path)
    trimmed_input = String.replace(file_content, "\n", "")
    stars_spec = get_stars_spec(String.graphemes(trimmed_input))
    get_gear_ratio(stars_spec)
  end

  @spec get_stars_spec(EngineSpec.t()) :: stars_spec()
  defp get_stars_spec(input) do
    get_stars_spec(%EngineSpec{content: input, size: length(input)}, input, [], %{}, 0)
  end

  @spec get_stars_spec(EngineSpec.t(), list(), list(), stars_spec(), Integer.t()) :: stars_spec()
  defp get_stars_spec(input, [head | tail ], number_digits_acc, stars_spec_acc, index) do
    if String.contains?(@digits, head) do
      get_stars_spec(input, tail, [head | number_digits_acc], stars_spec_acc, index + 1)
    else
      if number_digits_acc == [] do
        get_stars_spec(input, tail, number_digits_acc, stars_spec_acc, index + 1)
      else
        number = create_number_from_digits(number_digits_acc, 1, 0)
        digits_nb = length(number_digits_acc)
        new_star_spec_entries = calculate_stars_spec_for_number(input, index - 1, digits_nb, number)
        get_stars_spec(input, tail, [], merge_stars_specs(stars_spec_acc, new_star_spec_entries), index + 1)
      end
    end
  end

  @spec get_stars_spec(EngineSpec.t(), list(), list(), stars_spec(), Integer.t()) :: stars_spec()
  defp get_stars_spec(input, [], number_digits_acc, stars_spec_acc, index) do
    if number_digits_acc == [] do
      stars_spec_acc
    else
      number = create_number_from_digits(number_digits_acc, 1, 0)
      digits_nb = length(number_digits_acc)
      new_star_spec_entries = calculate_stars_spec_for_number(input, index, digits_nb, number)
      merge_stars_specs(stars_spec_acc, new_star_spec_entries)
    end
  end

  defp create_number_from_digits([head | tail], multiplier, acc) do
    {num, _} = Integer.parse(head)
    create_number_from_digits(tail, multiplier * 10, num * multiplier + acc)
  end

  defp create_number_from_digits([], _, acc) do
    acc
  end

  @spec calculate_stars_spec_for_number(EngineSpec.t(), Integer.t(), Integer.t(), Integer.t()) :: stars_spec()
  defp calculate_stars_spec_for_number(input, rightmost_digit_index, digits_nb, number) do
    leftmost_digit_index = rightmost_digit_index - digits_nb + 1

    # calculate top row
    stars_spec_for_top_row = calculate_partial_stars_spec(input, number, leftmost_digit_index - @nb_elems_in_row - 1, rightmost_digit_index - @nb_elems_in_row + 1,
      leftmost_digit_index, rightmost_digit_index)

    # calculate bottom row
    stars_spec_for_bottom_row = calculate_partial_stars_spec(input, number, leftmost_digit_index + @nb_elems_in_row - 1, rightmost_digit_index + @nb_elems_in_row + 1,
      leftmost_digit_index, rightmost_digit_index)

     # calculate element on the left
     stars_spec_for_left = case truncate_left_index_to_valid_value(input.size, leftmost_digit_index - 1, leftmost_digit_index) do
      {:out_of_bounds} -> %{}
      {:ok, left_index} -> create_stars_spec(input, number, left_index, left_index)
     end

     # calculate element on the right
     stars_spec_for_right = case truncate_right_index_to_valid_value(input.size, rightmost_digit_index + 1, rightmost_digit_index) do
      {:out_of_bounds} -> %{}
      {:ok, right_index} -> create_stars_spec(input, number, right_index, right_index)
     end

     Map.merge(Map.merge(stars_spec_for_top_row, stars_spec_for_bottom_row), Map.merge(stars_spec_for_left, stars_spec_for_right))
  end

  defp calculate_partial_stars_spec(input, number, left_index, right_index, leftmost_digit_index, rightmost_digit_index) do
    case truncate_left_index_to_valid_value(input.size, left_index, leftmost_digit_index) do
      {:ok, truncated_left_index} -> truncate_right_index_to_valid_value(input.size, right_index, rightmost_digit_index)
        |> (&create_stars_spec(input, number, truncated_left_index, elem(&1, 1))).()
      {:out_of_bounds} -> %{}
    end
  end

  defp truncate_left_index_to_valid_value(input_size, index, leftmost_digit_index) do
    cond do
      index < 0 -> {:out_of_bounds}
      index > input_size -> {:out_of_bounds}
      rem(index, @nb_elems_in_row) > rem(leftmost_digit_index, @nb_elems_in_row) -> {:ok, index + 1}
      True -> {:ok, index}
    end
  end

  defp truncate_right_index_to_valid_value(input_size, index, rightmost_digit_index) do
    cond do
      index < 0 -> {:out_of_bounds}
      index > input_size -> {:out_of_bounds}
      rem(index, @nb_elems_in_row) < rem(rightmost_digit_index, @nb_elems_in_row) -> {:ok, index - 1}
      True -> {:ok, index}
    end
  end

  defp create_stars_spec(input, number, left_index, right_index) do
    Enum.reduce(left_index..right_index, %{}, fn elem_index, acc ->
      if Enum.at(input.content, elem_index) == "*" do
        Map.put(acc, elem_index, [number])
      else
        acc
      end
    end)
  end

  defp merge_stars_specs(left, right) do
    Enum.reduce(right, left, fn {key, value}, acc -> add_number_to_star_spec(acc, key, value) end)
  end

  defp add_number_to_star_spec(map, key, sub_list_to_add) do
    if Map.has_key?(map, key) do
      Map.put(map, key, Map.get(map, key) ++ sub_list_to_add)
    else
      Map.put(map, key, sub_list_to_add)
    end
  end

  defp get_gear_ratio(stars_spec) do
    Enum.map(stars_spec, fn {_, value} -> if length(value) == 2 do
          Enum.at(value, 0) * Enum.at(value, 1)
        else
          0
        end
      end
    ) |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

end

IO.puts(Puzzle03_2.solve())
