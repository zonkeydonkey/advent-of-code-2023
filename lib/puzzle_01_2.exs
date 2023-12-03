defmodule Puzzle01_2 do
  @input_file_path "priv/puzzle_01_input.txt"
  @numbers_string_pattern "0123456789"

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(file_content)
  end

  defp solve(input) do
    for word <- String.split(input, ["\n"]),
        first_num = find_first(word),
        word_reversed = String.reverse(word),
        last_num = find_last(word_reversed) do
      first_num * 10 + last_num
    end |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

  defp find_first(word) do
    head = String.at(word, 0)
    if String.contains?(@numbers_string_pattern, head) do
      elem(Integer.parse(head), 0)
    else
      case word do
        "one" <> _ -> 1
        "two" <> _ -> 2
        "three" <> _ -> 3
        "four" <> _ -> 4
        "five" <> _ -> 5
        "six" <> _ -> 6
        "seven" <> _ -> 7
        "eight" <> _ -> 8
        "nine" <> _ -> 9
        _ -> find_first(String.slice(word, 1..-1))
      end
    end
  end

  defp find_last(word) do
    head = String.at(word, 0)
    if String.contains?(@numbers_string_pattern, head) do
      elem(Integer.parse(head), 0)
    else
      case word do
        "eno" <> _ -> 1
        "owt" <> _ -> 2
        "eerht" <> _ -> 3
        "ruof" <> _ -> 4
        "evif" <> _ -> 5
        "xis" <> _ -> 6
        "neves" <> _ -> 7
        "thgie" <> _ -> 8
        "enin" <> _ -> 9
        _ -> find_last(String.slice(word, 1..-1))
      end
    end
  end

end


IO.puts(Puzzle01_2.solve())
