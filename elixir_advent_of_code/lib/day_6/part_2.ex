defmodule Day6.Part2 do
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

  def part_2(grid) do
    guard_coordinates = find_guard_coordinates(grid)

    {:halt, final_grid, _guard_coordinates, obstacles_hit, loops, loop_count} =
      walk_grid(grid, guard_coordinates, [], [], 0)

    count_guard_positions(final_grid)

    IO.inspect(loops, label: "loops")

    Enum.uniq(loops)
    |> Enum.count()
    |> IO.inspect(label: "loop_count")

    loop_count
  end

  def count_guard_positions(grid) do
    Enum.reduce(grid, 0, fn {_x_index, row_map}, acc ->
      acc + Enum.count(row_map, fn {_y_index, cell} -> cell == :been_here end)
    end)
  end

  def find_guard_coordinates(grid) do
    Enum.reduce_while(grid, nil, fn {x_index, row_map}, _acc ->
      case Enum.find(row_map, fn {_y_index, cell} -> cell in [:up, :down, :left, :right] end) do
        nil -> {:cont, nil}
        {y_index, _guard} -> {:halt, {x_index, y_index}}
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

  def walk_grid(grid, guard_coordinates, obstacles_hit, loops, loop_count) do
    {_, _new_grid, _new_guard_coordinates, _new_obstacles_hit, loops, loop_count} =
      simulate_walk_grid(grid, guard_coordinates, obstacles_hit, loops, loop_count)

    IO.inspect(loop_count, label: "loop_count")

    case move_guard(grid, guard_coordinates, obstacles_hit, loops, loop_count) do
      {:cont, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count} ->
        # guard moved
        walk_grid(new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count)

      {:halt, grid, guard_coordinates, obstacles_hit, loops, loop_count} ->
        # guard walked off the grid
        {:halt, grid, guard_coordinates, obstacles_hit, loops, loop_count}
    end
  end

  def simulate_walk_grid(grid, guard_coordinates, obstacles_hit, loops, loop_count) do
    {_new_guard_direction, next_x, next_y} = get_next_guard_coordinates(grid, guard_coordinates)

    hypothetical_grid =
      case grid[next_x][next_y] do
        nil ->
          grid

        _ ->
          if length(obstacles_hit) > 0 do
            update_cell(grid, {next_x, next_y}, :obstacle)
          else
            grid
          end
      end

    case simulate_move_guard(
           hypothetical_grid,
           guard_coordinates,
           obstacles_hit,
           loops,
           loop_count
         ) do
      {:cont, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count} ->
        # guard moved
        simulate_walk_grid(new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count)

      {:halt, grid, guard_coordinates, obstacles_hit, loops, loop_count} ->
        # guard walked off the grid
        {:halt, grid, guard_coordinates, obstacles_hit, loops, loop_count}
    end
  end

  def move_guard(grid, guard_coordinates, obstacles_hit, loops, loop_count) do
    {current_x, current_y} = guard_coordinates
    current_guard_direction = grid[current_x][current_y]

    {new_guard_direction, next_x, next_y} =
      get_next_guard_coordinates(grid, guard_coordinates)

    case grid[next_x][next_y] do
      nil ->
        {new_grid, new_guard_coordinates, new_direction} =
          handle_turn(grid, guard_coordinates, new_guard_direction)

        {:halt, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count}

      :obstacle ->
        {new_grid, new_guard_coordinates, new_direction} =
          handle_turn(grid, guard_coordinates, new_guard_direction)

        {:cont, new_grid, new_guard_coordinates,
         obstacles_hit ++ [{current_guard_direction, :obstacle, next_x, next_y}], loops,
         loop_count}

      _ ->
        new_guard_coordinates = {next_x, next_y}

        new_grid =
          update_grid(grid, guard_coordinates, new_guard_coordinates, current_guard_direction)

        {:cont, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count}
    end
  end

  def simulate_move_guard(grid, guard_coordinates, obstacles_hit, loops, loop_count) do
    {current_guard_direction, next_x, next_y} =
      get_next_guard_coordinates(grid, guard_coordinates)

    {new_grid, new_guard_coordinates, new_direction} =
      handle_turn(grid, guard_coordinates, current_guard_direction)

    case grid[next_x][next_y] do
      nil ->
        {new_grid, new_guard_coordinates, new_direction} =
          handle_turn(grid, guard_coordinates, current_guard_direction)

        {:halt, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count}

      :obstacle ->
        IO.inspect({current_guard_direction, :obstacle, next_x, next_y}, label: "obstacle_hit")
        IO.inspect(obstacles_hit)

        Enum.any?(obstacles_hit, fn {direction, obstacle, x, y} ->
          direction == current_guard_direction and obstacle == :obstacle and x == next_x and
            y == next_y
        end)
        |> IO.inspect(label: "already_hit")
        |> case do
          true ->
            loop = Enum.take(obstacles_hit, -4)
            IO.inspect(loop, label: "loop")

            {:halt, new_grid, new_guard_coordinates, obstacles_hit, loops ++ [loop],
             loop_count + 1}

          false ->
            {:cont, new_grid, new_guard_coordinates,
             obstacles_hit ++ [{current_guard_direction, :obstacle, next_x, next_y}], loops,
             loop_count}
        end

      # {:cont, new_grid, new_guard_coordinates,
      #  obstacles_hit ++ [{current_guard_direction, :obstacle, next_x, next_y}]}

      _ ->
        new_guard_coordinates = {next_x, next_y}

        new_grid =
          update_grid(grid, guard_coordinates, new_guard_coordinates, current_guard_direction)

        {:cont, new_grid, new_guard_coordinates, obstacles_hit, loops, loop_count}
    end
  end

  def handle_turn(grid, guard_coordinates, direction) do
    new_direction = turn(direction)
    {x_index, y_index} = guard_coordinates
    {move_x, move_y} = move(new_direction)

    next_x = x_index + move_x
    next_y = y_index + move_y

    new_guard_coordinates = {next_x, next_y}
    new_grid = update_grid(grid, guard_coordinates, new_guard_coordinates, new_direction)

    {new_grid, new_guard_coordinates, new_direction}
  end

  def get_next_guard_coordinates(grid, guard_coordinates) do
    {x_index, y_index} = guard_coordinates
    guard_direction = grid[x_index][y_index]

    {move_x, move_y} = move(guard_direction)

    next_x = x_index + move_x
    next_y = y_index + move_y

    {guard_direction, next_x, next_y}
  end

  def check_for_loops(grid, guard_coordinates) do
    {guard_direction, next_x, next_y} = get_next_guard_coordinates(grid, guard_coordinates)

    hypothetical_grid = update_cell(grid, {next_x, next_y}, :obstacle)
    obstacle_coordinates = find_obstacle_coordinates(hypothetical_grid)

    Enum.reduce(obstacle_coordinates, [], fn {obstacle, x, y}, acc ->
      {move_x, move_y} = move(guard_direction)

      acc ++ [{guard_direction, obstacle, x, y}]
    end)
  end

  def calculate_next_hit_obstacle(hypothetical_grid, guard_coordinates) do
    {x_index, y_index} = guard_coordinates
    guard_direction = hypothetical_grid[x_index][y_index]
    obstacle_coordinates = find_obstacle_coordinates(hypothetical_grid)
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