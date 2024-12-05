defmodule Day4Test do
  use ExUnit.Case

  test "part 1 sample" do
    test_input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    block = Day4.Part1.create_block(test_input)

    assert block[0][0] == "M"
    assert block[0][1] == "M"
    assert block[0][2] == "M"
    assert block[0][3] == "S"
    assert block[0][4] == "X"
    assert block[0][5] == "X"
    assert block[0][6] == "M"
    assert block[0][7] == "A"
    assert block[0][8] == "S"
    assert block[0][9] == "M"

    assert Day4.Part1.find_xmases(block, 0, 5) == [
             false,
             false,
             false,
             true,
             false,
             false,
             false,
             false
           ]

    assert Day4.Part1.scan_block(block) == 18

    assert Day4.Part1.run() == 2569
  end

  test "part 2 sample" do
    test_input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    block = Day4.Part2.create_block(test_input)

    assert Day4.Part2.x_mas(block, 1, 2) == true
    assert Day4.Part2.scan_block_for_x_mases(block) == 9

    assert Day4.Part2.run() == 1998
  end
end
