defmodule Day7.Day7Parser do
  import NimbleParsec

  # """
  # 190: 10 19
  # 3267: 81 40 27
  # 83: 17 5
  # 156: 15 6
  # 7290: 6 8 6 15
  # 161011: 16 10 13
  # 192: 17 8 14
  # 21037: 9 7 18 13
  # 292: 11 6 16 20
  # """

  total =
    integer(min: 1)
    |> ignore(string(":"))
    |> ignore(string(" "))
    |> tag(:total)

  # |> integer(min: 1)
  # |> ignore(string(" "))

  value =
    integer(min: 1)
    |> ignore(optional(string(" ")))
    |> repeat()
    |> tag(:values)

  equation =
    total
    |> concat(value)
    |> reduce({__MODULE__, :to_equation, []})
    |> ignore(optional(string("\n")))
    |> repeat()

  # |> repeat()

  # parser =
  #   total
  #   # |> concat(value)

  # |> reduce({__MODULE__, :to_result, []})

  defparsec(:parse_input, equation)

  def to_equation(equations) do
    Enum.reduce(equations, %{}, fn
      {:values, value}, acc ->
        Map.put(acc, :values, value)

      {:total, [total]}, acc ->
        Map.put(acc, :total, total)
    end)
  end
end
