defmodule Day3Test do
  use ExUnit.Case

  test "parses the sample input correctly" do
    sample_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

    assert Day3.Part1.parse_input(sample_input) == %{total: 161}
  end

  test "parses the input file correctly" do
    assert Day3.Part1.run() == %{total: 178_886_550}
  end

  test "parses the choice sample input correctly" do
    sample_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    assert Day3.Part2.parse_input(sample_input) == {:enabled, 48}
  end

  test "parses the part 2 input file correctly" do
    assert Day3.Part2.run() == {:enabled, 87_163_705}
  end
end
