defmodule Day8.Part1 do
  @moduledoc """
  Day 8: Antenna Mapping (Part 1)

  Part 1 calculates antinode positions by finding reflection points between pairs of antennas.
  For each antenna pair, we calculate two antinode points that are equidistant from each antenna.

  The solution counts the total number of valid reflection points across all antenna pairs.
  """

  def part_1_file do
    grid = Day8.run_file()
    antenna_positions = Day8.find_antenna_positions(grid)
    antenna_groups = Day8.group_antennas_by_name(grid, antenna_positions)
    antenna_pairs = Day8.make_unique_antenna_pairs(antenna_groups)
    node_list = place_antinodes(grid, antenna_pairs)
    MapSet.size(node_list)
  end

  def calculate_antinode_coordinates({x1, y1} = _antenna_1, {x2, y2} = _antenna_2) do
    nx1 = 2 * x1 - x2
    ny1 = 2 * y1 - y2
    nx2 = 2 * x2 - x1
    ny2 = 2 * y2 - y1
    [{nx1, ny1}, {nx2, ny2}]
  end

  def place_antinodes(grid, antenna_pairs) do
    Enum.reduce(antenna_pairs, MapSet.new(), fn {antenna_1, antenna_2} = _pair, acc ->
      [node_1, node_2] = calculate_antinode_coordinates(antenna_1, antenna_2)

      acc
      |> Day8.place_antinode(grid, node_1)
      |> Day8.place_antinode(grid, node_2)
    end)
  end
end
