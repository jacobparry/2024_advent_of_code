defmodule Day4.Part2 do
  def run do
    input =
      File.read!("lib/day_4/day_4_input.txt")

    parse_input(input)
  end

  def parse_input(input) do
    input
    |> create_block()
    |> scan_block_for_x_mases()
  end

  def create_block(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, index}, acc ->
      l =
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Map.new(fn {v, i} -> {i, v} end)

      Map.put(acc, index, l)
    end)
  end

  def scan_block_for_x_mases(block) do
    Enum.reduce(block, 0, fn {x_index, row}, acc ->
      count =
        Enum.map(row, fn {y_index, _} ->
          find_x_mases(block, x_index, y_index)
          |> Enum.count(fn x -> x == true end)
        end)
        |> Enum.sum()

      acc + count
    end)
  end

  def x_mas(block, x, y) do
    center_value = block[x][y]
    top_left_value = block[x - 1][y - 1]
    top_right_value = block[x + 1][y - 1]
    bottom_left_value = block[x - 1][y + 1]
    bottom_right_value = block[x + 1][y + 1]

    x_one =
      [top_left_value, bottom_right_value]

    x_two =
      [top_right_value, bottom_left_value]

    check_x_mas(center_value, x_one) and check_x_mas(center_value, x_two)
  end

  def check_x_mas(center_value, list) do
    Enum.any?(list, fn letter -> letter == "M" end) and
      center_value == "A" and
      Enum.any?(list, fn letter -> letter == "S" end)
  end

  def find_x_mases(block, x, y) do
    [x_mas(block, x, y)]
  end
end
