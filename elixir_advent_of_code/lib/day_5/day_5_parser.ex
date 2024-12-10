defmodule Day5.Day5Parser do
  import NimbleParsec

  rule =
    integer(2)
    |> ignore(string("|"))
    |> integer(2)
    # |> tag(:rule)
    |> reduce({__MODULE__, :to_rule, []})

  update =
    integer(2)
    |> ignore(optional(string(",")))
    |> repeat()

    # |> tag(:update)

    |> reduce({__MODULE__, :to_update, []})

  rules_section = repeat(rule |> ignore(string("\n")))
  updates_section = repeat(update |> ignore(string("\n")))

  parser =
    rules_section
    |> ignore(string("\n"))
    |> concat(updates_section)
    |> reduce({__MODULE__, :to_result, []})

  # Expose the parser
  defparsec(:parse_input, parser)

  def to_rule([x, y]) do
    {:rule, x, y}
  end

  def to_update(updates) do
    {:update, updates}
  end

  def to_result(results) do
    Enum.reduce(results, %{rules: [], updates: []}, fn
      {:rule, x, y}, acc ->
        Map.put(acc, :rules, acc.rules ++ [[x, y]])

      {:update, updates}, acc ->
        Map.put(acc, :updates, acc.updates ++ [updates])
    end)
  end
end
