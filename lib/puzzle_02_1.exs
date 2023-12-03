defmodule Puzzle02_1 do
  @input_file_path "priv/puzzle_02_input.txt"
  @red_cubes_nb 12
  @green_cubes_nb 13
  @blue_cubes_nb 14

  def solve() do
    file_content = File.read!(@input_file_path)
    solve(file_content)
  end

  defp solve(input) do
    for game <- String.split(input, ["\n"]),
        "Game " <> game_description = game,
        [game_number, game_results] = String.split(game_description, [":"]) do
      solve_for_game(game_results, game_number)
    end |>
    Enum.reduce(fn x, acc -> x + acc end)
  end

  defp solve_for_game(game_results, game_number_str) do
    all_game_results_valid? = String.split(game_results, [";"]) |>
    Enum.flat_map(fn game_result -> String.split(game_result, [","]) end) |>
    Enum.all?(&(valid_cube_result?/1))

    if all_game_results_valid? do
      {game_number, _} = Integer.parse(game_number_str)
      game_number
    else
      0
    end
  end

  defp valid_cube_result?(cube_result) do
    [color_nb_str, color] = String.split(cube_result)
    {color_nb, _} = Integer.parse(color_nb_str)
    case color do
      "red" -> color_nb <= @red_cubes_nb
      "green" -> color_nb <= @green_cubes_nb
      "blue" -> color_nb <= @blue_cubes_nb
    end
  end

end

IO.puts(Puzzle02_1.solve())
