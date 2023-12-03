defmodule Puzzle02_2 do
  @input_file_path "priv/puzzle_02_input.txt"

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(file_content)
  end

  defp solve(input) do
    for game <- String.split(input, ["\n"]),
        "Game " <> game_description = game,
        [_, game_results] = String.split(game_description, [":"]) do
      solve_for_game(game_results)
    end |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

  defp solve_for_game(game_results) do
    String.split(game_results, [";"]) |>
    Enum.flat_map(fn game_result -> String.split(game_result, [","]) end) |>
    solve_for_game(%{red: 0, green: 0, blue: 0})
  end

  defp solve_for_game([head | tail], %{red: red_nb, green: green_nb, blue: blue_nb} = current_max_color_nb) do
    [color_nb_str, color] = String.split(head)
    {color_nb, _} = Integer.parse(color_nb_str)

    updated_max_color_nb = case color do
      "red" -> if red_nb < color_nb do Map.put(current_max_color_nb, :red, color_nb) else current_max_color_nb end
      "green" -> if green_nb < color_nb do Map.put(current_max_color_nb, :green, color_nb) else current_max_color_nb end
      "blue" -> if blue_nb < color_nb do Map.put(current_max_color_nb, :blue, color_nb) else current_max_color_nb end
    end
    solve_for_game(tail, updated_max_color_nb)
  end

  defp solve_for_game([], %{red: red_nb, green: green_nb, blue: blue_nb}) do
    red_nb * green_nb * blue_nb
  end

end

IO.puts(Puzzle02_2.solve())
