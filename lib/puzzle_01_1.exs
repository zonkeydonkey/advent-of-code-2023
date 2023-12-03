defmodule Puzzle01_1 do
  @input_file_path "priv/puzzle_01_input.txt"
  @numbers_string_pattern "0123456789"

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(file_content)
  end

  defp solve(input) do
    for word <- String.split(input, ["\n"]),
        word_reversed = String.reverse(word),
        word_graphemes = String.graphemes(word),
        word_graphemes_reversed = String.graphemes(word_reversed),
        find_first_numeral = fn x -> String.contains?(@numbers_string_pattern, x) end,
        first_num_char = Enum.find(word_graphemes, find_first_numeral),
        last_num_char = Enum.find(word_graphemes_reversed, find_first_numeral),
        {first_num, _} = Integer.parse(first_num_char),
        {last_num, _} = Integer.parse(last_num_char) do
      first_num * 10 + last_num
    end |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

end


IO.puts(Puzzle01_1.solve())
