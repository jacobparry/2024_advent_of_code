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
    guard_state = find_guard_state(grid)

    {:halt, final_grid, _guard_state, places_been, obstacles_hit, loop_count} =
      walk_grid(grid, guard_state, MapSet.new(), MapSet.new(), 0)

    count_guard_positions(final_grid)

    # Enum.uniq(loops)
    # |> Enum.count()
    # |> IO.inspect(label: "loop_count")

    count_guard_positions(final_grid)
    |> IO.inspect(label: "count_guard_positions")

    IO.inspect(loop_count, label: "loop_count")
    loop_count
  end

  def count_guard_positions(grid) do
    Enum.reduce(grid, 0, fn {_x_index, row_map}, acc ->
      acc + Enum.count(row_map, fn {_y_index, cell} -> cell == :been_here end)
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

  def walk_grid(grid, guard_state, places_been, obstacles_hit, loop_count) do
    {_new_guard_direction, next_x, next_y} = get_next_guard_state(grid, guard_state)

    hypo_grid =
      if MapSet.size(obstacles_hit) > 0 and grid[next_x][next_y] != nil do
        # IO.inspect("placing obstacle at #{next_x}, #{next_y}")
        update_cell(grid, {next_x, next_y}, :obstacle)
      else
        grid
      end

    {_, _new_grid, _new_guard_state, _new_places_been, _new_obstacles_hit, loop_count} =
      simulate_walk_grid(hypo_grid, guard_state, places_been, obstacles_hit, loop_count)

    # IO.inspect(guard_state, label: "guard_state")
    # IO.inspect(places_been, label: "places_been")

    # IO.inspect(loop_count, label: "loop_count")

    case move_guard(grid, guard_state, places_been, obstacles_hit, loop_count) do
      {:cont, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count} ->
        # guard moved
        walk_grid(new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count)

      {:halt, grid, guard_state, new_places_been, obstacles_hit, loop_count} ->
        # guard walked off the grid
        {:halt, grid, guard_state, new_places_been, obstacles_hit, loop_count}
    end
  end

  def move_guard(grid, guard_state, places_been, obstacles_hit, loop_count) do
    {current_guard_direction, current_x, current_y} = guard_state

    # IO.inspect(guard_state, label: "guard_state with regular move")
    new_places_been = MapSet.put(places_been, guard_state)

    {new_guard_direction, next_x, next_y} =
      get_next_guard_state(grid, guard_state)

    case grid[next_x][next_y] do
      nil ->
        {new_grid, new_guard_state, new_direction} =
          handle_turn(grid, guard_state)

        {:halt, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count}

      :obstacle ->
        {new_grid, new_guard_state, new_direction} =
          handle_turn(grid, guard_state)

        hit_obstacle =
          {:obstacle, next_x, next_y}

        # |> IO.inspect(label: "hit_obstacle")

        obstacles_hit = MapSet.put(obstacles_hit, hit_obstacle)

        {:cont, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count}

      _ ->
        new_guard_state = {current_guard_direction, next_x, next_y}

        new_grid =
          update_grid(grid, guard_state, new_guard_state)

        {:cont, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count}
    end
  end

  def simulate_walk_grid(grid, guard_state, places_been, obstacles_hit, loop_count) do
    case simulate_move_guard(grid, guard_state, places_been, obstacles_hit, loop_count) do
      {:cont, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count} ->
        # guard moved
        simulate_walk_grid(
          new_grid,
          new_guard_state,
          new_places_been,
          obstacles_hit,
          loop_count
        )

      {:halt, grid, guard_state, new_places_been, obstacles_hit, loop_count} ->
        # guard walked off the grid
        {:halt, grid, guard_state, new_places_been, obstacles_hit, loop_count}
    end
  end

  def simulate_move_guard(grid, guard_state, places_been, obstacles_hit, loop_count) do
    {current_guard_direction, current_x, current_y} = guard_state

    # IO.inspect(guard_state, label: "guard_state with simulate_move_guard")
    new_places_been = MapSet.put(places_been, guard_state)

    if MapSet.member?(places_been, guard_state) do
      # IO.inspect(guard_state, label: "current_guard_state")
      # IO.inspect(places_been, label: "places_been")
      # # IO.inspect(guard_state, label: "guard_state")
      # IO.inspect(loop_count, label: "loop_count")

      {:halt, grid, guard_state, places_been, obstacles_hit, loop_count + 1}
    else
      # |> IO.inspect(label: "new_places_been")

      {current_guard_direction, next_x, next_y} =
        get_next_guard_state(grid, guard_state)

      case grid[next_x][next_y] do
        nil ->
          {new_grid, new_guard_state, new_direction} =
            handle_turn(grid, guard_state)

          {:halt, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count}

        :obstacle ->
          {new_grid, new_guard_state, new_direction} =
            handle_turn(grid, guard_state)

          hit_obstacle = {:obstacle, next_x, next_y}
          obstacles_hit = MapSet.put(obstacles_hit, hit_obstacle)

          {:cont, grid, new_guard_state, new_places_been, obstacles_hit, loop_count}

        _ ->
          new_guard_state = {current_guard_direction, next_x, next_y}

          new_grid =
            update_grid(grid, guard_state, new_guard_state)

          {:cont, new_grid, new_guard_state, new_places_been, obstacles_hit, loop_count}
      end
    end
  end

  def handle_turn(grid, guard_state) do
    {current_guard_direction, current_x, current_y} = guard_state
    new_direction = turn(current_guard_direction)
    {move_x, move_y} = move(new_direction)

    next_x = current_x + move_x
    next_y = current_y + move_y

    new_guard_state = {new_direction, next_x, next_y}
    new_grid = update_grid(grid, guard_state, new_guard_state)

    {new_grid, new_guard_state, new_direction}
  end

  def get_next_guard_state(grid, guard_state) do
    # IO.inspect(guard_state, label: "guard_state")
    {current_guard_direction, current_x, current_y} = guard_state

    {move_x, move_y} = move(current_guard_direction)

    next_x = current_x + move_x
    next_y = current_y + move_y

    {current_guard_direction, next_x, next_y}
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
