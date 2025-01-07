defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Day9Parser.parse_input" do
    input = "23331"
    expected = [{0, 2}, {1, 3}, {2, 3}, {3, 3}, {4, 1}]

    result = Day9Parser.parse_input(Day9.sample_input())

    assert {:ok, [2, 3, 3, 3, 1, 3, 3, 1, 2, 1, 4, 1, 4, 1, 3, 1, 4, 0, 2], "", %{}, {1, 0}, 19} ==
             result
  end

  test "Day9.parse_input" do
    result = Day9.parse_input(Day9.sample_input())

    assert result == [2, 3, 3, 3, 1, 3, 3, 1, 2, 1, 4, 1, 4, 1, 3, 1, 4, 0, 2]
  end

  test "Day9.create_indexed_list" do
    input = Day9.parse_input(Day9.sample_input())

    result = Day9.create_indexed_list(input)

    assert %{
             0 => 2,
             1 => 3,
             2 => 3,
             3 => 3,
             4 => 1,
             5 => 3,
             6 => 3,
             7 => 1,
             8 => 2,
             9 => 1,
             10 => 4,
             11 => 1,
             12 => 4,
             13 => 1,
             14 => 3,
             15 => 1,
             16 => 4,
             17 => 0,
             18 => 2
           } == result
  end

  test "Day9.create_file_block" do
    input = Day9.parse_input(Day9.sample_input())
    indexed_list = Day9.create_indexed_list(input)

    result = Day9.create_file_block({0, 2})

    assert result == [0, 0]

    result = Day9.create_file_block({1, 3})
    assert result == [".", ".", "."]

    result = Day9.create_file_block({17, 0})
    assert result == []
  end
end
