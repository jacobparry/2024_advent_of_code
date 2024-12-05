defmodule Day3.Part1 do
  def run do
    input = File.read!("lib/day_3/day_3_input.txt")
    parse_input(input)
  end

  def parse_input(input) do
    {:ok, matches, _, _, _, _} = Day3.Part1Parser.parse_input(input)

    Enum.reduce(matches, %{total: 0}, fn {:mul, [a, b]}, acc ->
      %{acc | total: acc.total + a * b}
    end)
  end
end
