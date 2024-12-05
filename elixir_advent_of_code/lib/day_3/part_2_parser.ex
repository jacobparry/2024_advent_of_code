defmodule Day3.Part2Parser do
  import NimbleParsec

  disable =
    ignore(string("don't()"))
    |> tag(:disable)

  enable =
    ignore(string("do()"))
    |> tag(:enable)

  # Define the `mul(a,b)` parser
  mul =
    ignore(string("mul("))
    |> integer(min: 1, max: 3)
    |> ignore(string(","))
    |> integer(min: 1, max: 3)
    |> ignore(string(")"))
    |> tag(:mul)

  instruction = choice([disable, enable, mul])

  parser =
    instruction
    |> eventually()
    |> repeat()

  # Expose the parser
  defparsec(:parse_input, parser)
end
