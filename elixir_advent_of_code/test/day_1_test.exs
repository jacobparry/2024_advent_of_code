defmodule Day1Test do
  use ExUnit.Case

  test "parses the input file correctly" do
    assert Day1.run() == %{diff: 1_646_452, similarity: 23_609_874}
  end
end
