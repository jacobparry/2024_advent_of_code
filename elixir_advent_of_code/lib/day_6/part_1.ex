defmodule Day6.Part1 do
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

  def part_1(grid) do
    guard_coordinates = find_guard_coordinates(grid)

    {:halt, final_grid, _} = walk_grid(grid, guard_coordinates)

    count_guard_positions(final_grid)
  end

  def count_guard_positions(grid) do
    Enum.reduce(grid, 0, fn {_x_index, row_map}, acc ->
      acc + Enum.count(row_map, fn {_y_index, cell} -> cell == :been_here end)
    end)
  end

  def find_guard_coordinates(grid) do
    Enum.reduce_while(grid, nil, fn {x_index, row_map}, acc ->
      case Enum.find(row_map, fn {_y_index, cell} -> cell in [:up, :down, :left, :right] end) do
        nil -> {:cont, acc}
        {y_index, _guard} -> {:halt, {x_index, y_index}}
      end
    end)
  end

  def walk_grid(grid, guard_coordinates) do
    case move_guard(grid, guard_coordinates) do
      {:cont, new_grid, new_guard_coordinates} ->
        # guard moved
        walk_grid(new_grid, new_guard_coordinates)

      {:turn, new_grid, new_guard_coordinates} ->
        # guard turned
        walk_grid(new_grid, new_guard_coordinates)

      {:halt, grid, guard_coordinates} ->
        # guard walked off the grid
        {:halt, grid, guard_coordinates}
    end
  end

  def move_guard(grid, guard_coordinates) do
    {x_index, y_index} = guard_coordinates
    guard = grid[x_index][y_index]

    {move_x, move_y} = move(guard)

    next_x = x_index + move_x
    next_y = y_index + move_y

    case grid[next_x][next_y] do
      nil ->
        new_direction = turn(guard)
        {turn_x, turn_y} = move(new_direction)
        turn_next_x = x_index + turn_x
        turn_next_y = y_index + turn_y
        new_guard_coordinates = {turn_next_x, turn_next_y}
        new_grid = update_grid(grid, guard_coordinates, new_guard_coordinates, new_direction)

        {:halt, new_grid, new_guard_coordinates}

      :obstacle ->
        new_direction = turn(guard)
        {turn_x, turn_y} = move(new_direction)
        turn_next_x = x_index + turn_x
        turn_next_y = y_index + turn_y
        new_guard_coordinates = {turn_next_x, turn_next_y}
        new_grid = update_grid(grid, guard_coordinates, new_guard_coordinates, new_direction)
        {:cont, new_grid, new_guard_coordinates}

      _ ->
        new_guard_coordinates = {next_x, next_y}
        new_grid = update_grid(grid, guard_coordinates, new_guard_coordinates, guard)
        {:cont, new_grid, new_guard_coordinates}
    end
  end

  def update_grid(grid, {old_x, old_y} = _old_guard_coordinates, {new_x, new_y}, guard) do
    grid
    |> update_cell({old_x, old_y}, :been_here)
    |> update_cell({new_x, new_y}, guard)
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
