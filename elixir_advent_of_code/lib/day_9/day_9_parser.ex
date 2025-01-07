defmodule Day9Parser do
  @moduledoc """
  Parser for Day 9 input
  """
  import NimbleParsec

  digit = integer(1)

  parser =
    digit
    |> repeat()
    |> eos()

  defparsec(:parse_input, parser)
end
