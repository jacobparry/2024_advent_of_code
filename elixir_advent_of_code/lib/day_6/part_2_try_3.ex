defmodule Day6.Part2Try3 do
  @moduledoc """

  Part2Try3 is a much simpler approach and actually worked.

  I find every available empty spot.
  I remove the invalid empty spots (the ones that are between the guard and the first obstacle)
  I generate a new grid for each empty spot.
  I walk the guard through the grid and count the number of loops.
  """

  def run_file do
    input = File.read!("lib/day_6/day_6_input.txt")

    parse_input(input)
  end

  def run_sample(input) do
    parse_input(input)
  end

  def parse_input(input) do
    {:ok, [grid], _, _, _, _} = Day6.Day6Parser.parse_input(input)

    grid
  end

  def part_3 do
    grid = run_file()
    find_loop_count(grid)
  end

  def find_loop_count(grid) do
    guard_state = find_guard_state(grid)
    alternate_grids = make_alternate_grids(grid)

    Enum.reduce(alternate_grids, 0, fn grid, acc ->
      case walk_grid(grid, guard_state, MapSet.new()) do
        {:loop_detected, loop_count} ->
          acc + loop_count

        :no_loop ->
          acc
      end
    end)
  end

  # Generate grids with obstacles
  def make_alternate_grids(grid) do
    valid_empty_cells = get_valid_empty_cells_for_obstacle(grid)

    Enum.map(valid_empty_cells, fn {:empty, x, y} ->
      update_cell(grid, {x, y}, :obstacle)
    end)
  end

  def get_valid_empty_cells_for_obstacle(grid) do
    empty_cells = find_all_empty_cells(grid) |> MapSet.new()
    cells_to_remove = find_cells_between_guard_and_first_obstacle(grid) |> MapSet.new()

    MapSet.difference(empty_cells, cells_to_remove)
    |> MapSet.to_list()
  end

  def find_all_empty_cells(grid) do
    Enum.reduce(grid, [], fn {x_index, row_map}, acc ->
      Enum.reduce(row_map, acc, fn
        {y_index, :empty}, acc ->
          acc ++ [{:empty, x_index, y_index}]

        {_y_index, _cell}, acc ->
          acc
      end)
    end)
  end

  def find_cells_between_guard_and_first_obstacle(grid) do
    {_, guard_x, guard_y} = find_guard_state(grid)

    Enum.reduce_while(guard_x..0, [], fn row_index, acc ->
      case grid[row_index][guard_y] do
        :obstacle -> {:halt, acc}
        _ -> {:cont, acc ++ [{:empty, row_index, guard_y}]}
      end
    end)
  end

  def find_guard_state(grid) do
    Enum.reduce_while(grid, nil, fn {x_index, row_map}, _acc ->
      case Enum.find(row_map, fn {_y_index, cell} -> cell in [:up, :down, :left, :right] end) do
        nil -> {:cont, nil}
        {y_index, guard} -> {:halt, {guard, x_index, y_index}}
      end
    end)
  end

  def find_obstacle_coordinates(grid) do
    Enum.reduce(grid, [], fn {x_index, row_map}, acc ->
      case Enum.find(row_map, fn {_y_index, cell} -> cell == :obstacle end) do
        nil -> acc
        {y_index, cell} -> acc ++ [{cell, x_index, y_index}]
      end
    end)
  end

  def walk_grid(grid, guard_state, places_been) do
    if MapSet.member?(places_been, guard_state) do
      {:loop_detected, 1}
    else
      case move_guard(grid, guard_state) do
        {:cont, new_grid, new_guard_state} ->
          # guard moved
          new_places_been = MapSet.put(places_been, guard_state)

          walk_grid(new_grid, new_guard_state, new_places_been)

        {:halt, :no_loop} ->
          # guard walked off the grid
          :no_loop
      end
    end
  end

  def move_guard(grid, guard_state) do
    {current_guard_direction, current_x, current_y} = guard_state
    {move_x, move_y} = move(current_guard_direction)
    next_x = current_x + move_x
    next_y = current_y + move_y

    case grid[next_x][next_y] do
      nil ->
        {:halt, :no_loop}

      :obstacle ->
        {updated_grid, new_guard_state} =
          handle_turn(grid, guard_state)

        {:cont, updated_grid, new_guard_state}

      _ ->
        new_guard_state = {current_guard_direction, next_x, next_y}

        updated_grid =
          update_grid(grid, guard_state, new_guard_state)

        {:cont, updated_grid, new_guard_state}
    end
  end

  def handle_turn(grid, guard_state) do
    {current_guard_direction, current_x, current_y} = guard_state
    new_direction = turn(current_guard_direction)

    new_guard_state = {new_direction, current_x, current_y}
    new_grid = update_grid(grid, guard_state, new_guard_state)

    {new_grid, new_guard_state}
  end

  def update_grid(grid, {_, old_x, old_y}, {new_direction, new_x, new_y}) do
    grid
    |> update_cell({old_x, old_y}, :been_here)
    |> update_cell({new_x, new_y}, new_direction)
  end

  def update_cell(grid, {x, y}, value) do
    Map.update!(grid, x, fn row ->
      Map.put(row, y, value)
    end)
  end

  @doc """
  %{
    0 => %{0 => :empty, 1 => :empty, 2 => :empty},
    1 => %{0 => :empty, 1 => :empty, 2 => :up},
    2 => %{0 => :empty, 1 => :empty, 2 => :empty}
  }

  Selecting which row is actually the Y axis
  Selecting the cell value is the X axis

  For example:
  grid[1][2] == :up
  the [1] is the Y axis
  the [2] is the X axis
  """

  def move(:up), do: {-1, 0}
  def move(:down), do: {1, 0}
  def move(:left), do: {0, -1}
  def move(:right), do: {0, 1}

  def turn(:up), do: :right
  def turn(:down), do: :left
  def turn(:left), do: :up
  def turn(:right), do: :down
end
