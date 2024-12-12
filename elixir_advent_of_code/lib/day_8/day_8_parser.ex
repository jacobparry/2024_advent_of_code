defmodule Day8.Day8Parser do
  import NimbleParsec

  # """
  # ............
  # ........0...
  # .....0......
  # .......0....
  # ....0.......
  # ......A.....
  # ............
  # ............
  # ........A...
  # .........A..
  # ............
  # ............
  # """

  empty =
    string(".")
    |> replace(:empty)

  antenna =
    utf8_char([?a..?z, ?A..?Z, ?0..?9])
    |> unwrap_and_tag(:antenna)

  cell = choice([empty, antenna])

  row =
    cell
    |> repeat()
    |> reduce({__MODULE__, :to_row, []})

  grid =
    row
    |> ignore(string("\n"))
    |> repeat()
    |> reduce({__MODULE__, :to_grid, []})

  defparsec(:parse_input, grid)

  def to_row(row) do
    Enum.with_index(row, fn
      :empty, index ->
        {index, :empty}

      {:antenna, cell}, index ->
        {index, {:antenna, <<cell::utf8>>}}
    end)
    |> Enum.into(%{})
  end

  def to_grid(grid) do
    Enum.with_index(grid, fn row, index ->
      {index, row}
    end)
    |> Enum.into(%{})
  end
end
