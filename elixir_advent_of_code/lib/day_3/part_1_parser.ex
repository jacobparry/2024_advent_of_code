defmodule Day3.Part1Parser do
  import NimbleParsec

  # Define the `mul(a,b)` parser
  mul =
    ignore(string("mul("))
    |> integer(min: 1, max: 3)
    |> ignore(string(","))
    |> integer(min: 1, max: 3)
    |> ignore(string(")"))
    |> tag(:mul)

  parser =
    mul
    |> eventually()
    |> repeat()

  # Expose the parser
  defparsec(:parse_input, parser)
end
