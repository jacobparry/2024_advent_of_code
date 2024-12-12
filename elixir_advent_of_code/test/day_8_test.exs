defmodule Day8Test do
  use ExUnit.Case

  def sample_input do
    """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """
  end

  test "find antenna positions" do
    grid = Day8.parse_input(sample_input())

    assert Day8.find_antenna_positions(grid) == [
             {1, 8},
             {2, 5},
             {3, 7},
             {4, 4},
             {5, 6},
             {8, 8},
             {9, 9}
           ]
  end

  test "group antennas by name" do
    grid = Day8.parse_input(sample_input())
    antenna_positions = Day8.find_antenna_positions(grid)

    assert Day8.group_antennas_by_name(grid, antenna_positions) == %{
             "0" => [{1, 8}, {2, 5}, {3, 7}, {4, 4}],
             "A" => [{5, 6}, {8, 8}, {9, 9}]
           }
  end

  test "make unique antenna pairs" do
    antenna_groups = %{
      "0" => [{1, 8}, {2, 5}, {3, 7}, {4, 4}],
      "A" => [{5, 6}, {8, 8}, {9, 9}]
    }

    assert Day8.make_unique_antenna_pairs(antenna_groups) == [
             {{1, 8}, {2, 5}},
             {{1, 8}, {3, 7}},
             {{1, 8}, {4, 4}},
             {{2, 5}, {3, 7}},
             {{2, 5}, {4, 4}},
             {{3, 7}, {4, 4}},
             {{5, 6}, {8, 8}},
             {{5, 6}, {9, 9}},
             {{8, 8}, {9, 9}}
           ]
  end

  test "calculate_antinode_coordinates (Part 1)" do
    assert Day8.Part1.calculate_antinode_coordinates({1, 8}, {2, 5}) == [{0, 11}, {3, 2}]
    assert Day8.Part1.calculate_antinode_coordinates({1, 8}, {3, 7}) == [{-1, 9}, {5, 6}]
    assert Day8.Part1.calculate_antinode_coordinates({1, 8}, {4, 4}) == [{-2, 12}, {7, 0}]
    assert Day8.Part1.calculate_antinode_coordinates({2, 5}, {3, 7}) == [{1, 3}, {4, 9}]
    assert Day8.Part1.calculate_antinode_coordinates({2, 5}, {4, 4}) == [{0, 6}, {6, 3}]
    assert Day8.Part1.calculate_antinode_coordinates({3, 7}, {4, 4}) == [{2, 10}, {5, 1}]
  end

  test "place_antinodes (Part 1)" do
    grid = Day8.parse_input(sample_input())

    antenna_pairs =
      Day8.make_unique_antenna_pairs(
        Day8.group_antennas_by_name(grid, Day8.find_antenna_positions(grid))
      )

    results = Day8.Part1.place_antinodes(grid, antenna_pairs)

    assert results ==
             MapSet.new([
               {0, 6},
               {0, 11},
               {1, 3},
               {2, 4},
               {2, 10},
               {3, 2},
               {4, 9},
               {5, 1},
               {5, 6},
               {6, 3},
               {7, 0},
               {7, 7},
               {10, 10},
               {11, 10}
             ])

    assert MapSet.size(results) == 14
  end

  test "calculate_antinode_coordinates (Part 2)" do
    grid = Day8.parse_input(sample_input())
    assert Day8.Part2.calculate_antinode_coordinates({1, 8}, {2, 5}, grid) == [{3, 2}, {0, 11}]

    assert Day8.Part2.calculate_antinode_coordinates({1, 8}, {3, 7}, grid) == [
             {5, 6},
             {-1, 9},
             {11, 3},
             {9, 4},
             {7, 5}
           ]
  end

  test "place_antinodes (Part 2)" do
    grid = Day8.parse_input(sample_input())

    antenna_pairs =
      Day8.make_unique_antenna_pairs(
        Day8.group_antennas_by_name(grid, Day8.find_antenna_positions(grid))
      )

    results = Day8.Part2.place_antinodes(grid, antenna_pairs)

    assert results ==
             MapSet.new([
               {2, 4},
               {1, 1},
               {3, 7},
               {11, 3},
               {0, 1},
               {3, 2},
               {9, 4},
               {2, 10},
               {0, 0},
               {5, 6},
               {6, 6},
               {5, 11},
               {8, 8},
               {1, 8},
               {11, 10},
               {8, 2},
               {7, 5},
               {7, 0},
               {3, 3},
               {4, 9},
               {7, 7},
               {10, 10},
               {5, 5},
               {10, 1},
               {0, 11},
               {5, 1},
               {2, 5},
               {2, 2},
               {4, 4},
               {0, 6},
               {6, 3},
               {11, 11},
               {1, 3},
               {9, 9}
             ])

    assert MapSet.size(results) == 34
  end

  test "part 1" do
    assert Day8.Part1.part_1_file() == 311
  end

  test "part 2" do
    assert Day8.Part2.part_2_file() == 1115
  end
end
