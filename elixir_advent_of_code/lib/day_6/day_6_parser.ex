defmodule Day6.Day6Parser do
  import NimbleParsec

  empty =
    string(".")
    |> replace(:empty)

  obstacle =
    string("#")
    |> replace(:obstacle)

  guard =
    string("^")
    |> replace(:up)

  cell = choice([empty, obstacle, guard])

  row =
    cell
    |> repeat()
    |> reduce({__MODULE__, :to_row, []})

  grid =
    row
    |> ignore(string("\n"))
    |> repeat()
    |> reduce({__MODULE__, :to_grid, []})

  # Expose the parser
  defparsec(:parse_input, grid)

  def to_row(row) do
    Enum.with_index(row, fn cell, index ->
      {index, cell}
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
