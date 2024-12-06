defmodule Day4.Part1 do
  def run do
    input = File.read!("lib/day_4/day_4_input.txt")
    parse_input(input)
  end

  def parse_input(input) do
    input
    |> create_block()
    |> scan_block()
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

  def scan_block(block) do
    Enum.reduce(block, 0, fn {x_index, row}, acc ->
      count =
        Enum.map(row, fn {y_index, _} ->
          find_xmases(block, x_index, y_index)
          |> Enum.count(fn x -> x == true end)
        end)
        |> Enum.sum()

      acc + count
    end)
  end

  def left(block, x, y) do
    x_val = block[x][y]
    m_val = block[x - 1][y]
    a_val = block[x - 2][y]
    s_val = block[x - 3][y]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def right(block, x, y) do
    x_val = block[x][y]
    m_val = block[x + 1][y]
    a_val = block[x + 2][y]
    s_val = block[x + 3][y]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def up(block, x, y) do
    x_val = block[x][y]
    m_val = block[x][y - 1]
    a_val = block[x][y - 2]
    s_val = block[x][y - 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def down(block, x, y) do
    x_val = block[x][y]
    m_val = block[x][y + 1]
    a_val = block[x][y + 2]
    s_val = block[x][y + 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  # diagonals
  def up_left(block, x, y) do
    x_val = block[x][y]
    m_val = block[x - 1][y - 1]
    a_val = block[x - 2][y - 2]
    s_val = block[x - 3][y - 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def up_right(block, x, y) do
    x_val = block[x][y]
    m_val = block[x + 1][y - 1]
    a_val = block[x + 2][y - 2]
    s_val = block[x + 3][y - 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def down_left(block, x, y) do
    x_val = block[x][y]
    m_val = block[x - 1][y + 1]
    a_val = block[x - 2][y + 2]
    s_val = block[x - 3][y + 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def down_right(block, x, y) do
    x_val = block[x][y]
    m_val = block[x + 1][y + 1]
    a_val = block[x + 2][y + 2]
    s_val = block[x + 3][y + 3]

    if x_val == "X" and m_val == "M" and a_val == "A" and s_val == "S" do
      true
    else
      false
    end
  end

  def find_xmases(block, x, y) do
    [
      left(block, x, y),
      right(block, x, y),
      up(block, x, y),
      down(block, x, y),
      up_left(block, x, y),
      up_right(block, x, y),
      down_left(block, x, y),
      down_right(block, x, y)
    ]
  end
end
