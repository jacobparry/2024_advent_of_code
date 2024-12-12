defmodule Day8.Part2 do
  @moduledoc """
  Day 8: Antenna Mapping (Part 2)

  Part 2 extends the antinode calculation to include all points along the reflection line
  between antenna pairs. For each antenna pair, we:
  1. Calculate the initial antinode points
  2. Continue calculating anti points in both directions until we hit grid boundaries
  3. Include all valid points in the final count

  The solution counts all valid points including the original antenna positions.
  """

  def part_2_file do
    grid = Day8.run_file()
    antenna_positions = Day8.find_antenna_positions(grid)
    antenna_groups = Day8.group_antennas_by_name(grid, antenna_positions)
    antenna_pairs = Day8.make_unique_antenna_pairs(antenna_groups)
    node_list = place_antinodes(grid, antenna_pairs)
    MapSet.size(node_list)
  end

  def calculate_antinode_coordinates({x1, y1} = antenna_1, {x2, y2} = antenna_2, grid) do
    nx1 = 2 * x1 - x2
    ny1 = 2 * y1 - y2
    nx2 = 2 * x2 - x1
    ny2 = 2 * y2 - y1

    node_1 = {nx1, ny1}
    node_2 = {nx2, ny2}

    nodes_from_1 = calculate_next_antinode(antenna_1, node_1, [], grid)
    nodes_from_2 = calculate_next_antinode(antenna_2, node_2, [], grid)

    [node_2, node_1] ++ nodes_from_1 ++ nodes_from_2
  end

  def calculate_next_antinode({ax, ay} = _anchor, {cx, cy} = _current, acc, grid) do
    nx = 2 * cx - ax
    ny = 2 * cy - ay

    case grid[nx] && grid[nx][ny] do
      nil ->
        acc

      _ ->
        acc = [{nx, ny} | acc]
        calculate_next_antinode({cx, cy}, {nx, ny}, acc, grid)
    end
  end

  def place_antinodes(grid, antenna_pairs) do
    Enum.reduce(antenna_pairs, MapSet.new(), fn {antenna_1, antenna_2} = _pair, acc ->
      nodes = calculate_antinode_coordinates(antenna_1, antenna_2, grid)

      nodes
      |> Enum.reduce(acc, fn node, acc -> Day8.place_antinode(acc, grid, node) end)
      |> Day8.place_antinode(grid, antenna_1)
      |> Day8.place_antinode(grid, antenna_2)
    end)
  end
end
