defmodule Day3.Part2 do
  def run do
    input = File.read!("lib/day_3/day_3_input.txt")
    parse_input(input)
  end

  def parse_input(input) do
    {:ok, matches, _, _, _, _} =
      Day3.Part2Parser.parse_input(input)

    Enum.reduce(matches, {:enabled, 0}, fn
      {:mul, [a, b]}, {:enabled, acc} ->
        {:enabled, acc + a * b}

      {:disable, _}, {:enabled, acc} ->
        {:disabled, acc}

      {:enable, _}, {:disabled, acc} ->
        {:enabled, acc}

      _, acc ->
        acc
    end)
  end
end
