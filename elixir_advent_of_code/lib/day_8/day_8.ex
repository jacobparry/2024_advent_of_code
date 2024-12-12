defmodule Day8 do
  @moduledoc """
  Day 8: Antenna Mapping

  Common functionality for solving the antenna mapping puzzle. This module contains
  shared functions used by both Part 1 and Part 2 solutions.

  The puzzle involves finding positions of antinodes based on antenna positions in a grid.
  Antinodes are calculated using reflection points between pairs of antennas.
  """

  def run_file do
    input = File.read!("lib/day_8/day_8_input.txt")
    parse_input(input)
  end

  def parse_input(input) do
    {:ok, [grid], _, _, _, _} = Day8.Day8Parser.parse_input(input)
    grid
  end

  def find_antenna_positions(grid) do
    Enum.reduce(grid, [], fn {x_index, row_map}, acc ->
      antenna_positions =
        Enum.reduce(row_map, [], fn {y_index, cell}, acc ->
          case cell do
            {:antenna, _antenna} -> acc ++ [{x_index, y_index}]
            _ -> acc
          end
        end)

      acc ++ antenna_positions
    end)
  end

  def group_antennas_by_name(grid, antenna_positions) do
    Enum.reduce(antenna_positions, %{}, fn {x_index, y_index} = antenna_position, acc ->
      {:antenna, antenna_name} = grid[x_index][y_index]
      existing_antennas = Map.get(acc, antenna_name, [])
      Map.put(acc, antenna_name, existing_antennas ++ [antenna_position])
    end)
  end

  def make_unique_antenna_pairs(antenna_groups) do
    Enum.map(antenna_groups, fn {_antenna_name, antenna_positions} ->
      for i <- 0..(length(antenna_positions) - 2),
          j <- (i + 1)..(length(antenna_positions) - 1),
          do: {Enum.at(antenna_positions, i), Enum.at(antenna_positions, j)}
    end)
    |> List.flatten()
  end

  def place_antinode(node_list, grid, {x, y} = _node) do
    case grid[x][y] do
      nil -> node_list
      _ -> MapSet.put(node_list, {x, y})
    end
  end
end
