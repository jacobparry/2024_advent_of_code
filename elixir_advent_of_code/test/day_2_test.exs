defmodule Day2Test do
  use ExUnit.Case

  test "parses the input file correctly" do
    assert Day2.run() == %{safe: 285, unsafe: 715}
  end
end
