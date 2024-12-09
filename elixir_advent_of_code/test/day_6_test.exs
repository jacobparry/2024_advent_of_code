defmodule Day6Test do
  use ExUnit.Case

  test "parse input" do
    assert Day6.Part1.parse_input(sample_input()) ==
             %{
               0 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :obstacle,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               1 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :obstacle
               },
               2 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               3 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :obstacle,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               4 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :obstacle,
                 8 => :empty,
                 9 => :empty
               },
               5 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               6 => %{
                 0 => :empty,
                 1 => :obstacle,
                 2 => :empty,
                 3 => :empty,
                 4 => :up,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               7 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :obstacle,
                 9 => :empty
               },
               8 => %{
                 0 => :obstacle,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :empty,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               },
               9 => %{
                 0 => :empty,
                 1 => :empty,
                 2 => :empty,
                 3 => :empty,
                 4 => :empty,
                 5 => :empty,
                 6 => :obstacle,
                 7 => :empty,
                 8 => :empty,
                 9 => :empty
               }
             }
  end

  test "part 1" do
    grid = Day6.Part1.run_sample(sample_input())
    assert Day6.Part1.part_1(grid) == 41

    grid = Day6.Part1.run_file()
    assert Day6.Part1.part_1(grid) == 4758
  end

  test "guard coordinates" do
    grid = Day6.Part1.run_sample(sample_input())
    coordinates = Day6.Part1.find_guard_coordinates(grid)
    assert coordinates == {6, 4}
    {x, y} = coordinates
    assert grid[x][y] == :up
  end

  test "move guard" do
    grid = Day6.Part1.run_sample(sample_input())
    guard_coordinates = Day6.Part1.find_guard_coordinates(grid)
    assert guard_coordinates == {6, 4}

    {:cont, new_grid, new_guard_coordinates} = Day6.Part1.move_guard(grid, guard_coordinates)
    assert new_guard_coordinates == {5, 4}

    {:cont, new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {4, 4}

    {:cont, new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {3, 4}

    {:cont, new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {2, 4}

    {:cont, new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {1, 4}

    {:cont, new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {1, 5}

    {:cont, _new_grid, new_guard_coordinates} =
      Day6.Part1.move_guard(new_grid, new_guard_coordinates)

    assert new_guard_coordinates == {1, 6}
  end

  test "obstruction coordinates" do
    grid = Day6.Part2.run_sample(sample_input())

    assert Day6.Part2.find_obstacle_coordinates(grid) == [
             {:obstacle, 0, 4},
             {:obstacle, 1, 9},
             {:obstacle, 3, 2},
             {:obstacle, 4, 7},
             {:obstacle, 6, 1},
             {:obstacle, 7, 8},
             {:obstacle, 8, 0},
             {:obstacle, 9, 6}
           ]
  end

  test "part 2" do
    grid = Day6.Part2.run_sample(sample_input())
    assert Day6.Part2.part_2(grid) == 10
  end

  defp sample_input do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  end
end
