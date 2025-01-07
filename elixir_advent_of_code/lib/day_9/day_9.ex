defmodule Day9 do
  @moduledoc """
  Day 9: Main module
  """

  def file do
    "lib/day_9/day_9_input.txt"
  end

  def sample_input do
    "2333133121414131402"
  end

  def parse_input(input) do
    {:ok, result, "", %{}, {1, 0}, 19} =
      Day9Parser.parse_input(input)

    result
  end

  def create_indexed_list(input) do
    Enum.with_index(input, fn value, index -> {index, value} end)
    |> Enum.into(%{})
  end

  def create_file_block({_index, 0}) do
    []
  end

  def create_file_block({index, value}) do
    case rem(index, 2) do
      # even indices
      0 ->
        Enum.reduce(1..value, [], fn i, acc ->
          acc ++ [index]
        end)

      # odd indices
      1 ->
        Enum.reduce(1..value, [], fn i, acc ->
          acc ++ ["."]
        end)
    end
  end

  def create_file_block_from_list(list) do
    Enum.reduce(list, [], fn {index, value}, acc ->
      acc ++ create_file_block({index, value})
    end)
  end
end
