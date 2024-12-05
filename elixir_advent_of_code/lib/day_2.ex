defmodule Day2 do
  def run do
    input =
      File.read!("day_2_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " "))

    Enum.reduce(input, %{safe: 0, unsafe: 0}, fn report, acc ->
      result =
        report
        |> Enum.map(&String.to_integer/1)
        |> classify_report()

      case result do
        :safe ->
          Map.update(acc, :safe, 1, &(&1 + 1))

        :unsafe ->
          Map.update(acc, :unsafe, 1, &(&1 + 1))
      end
    end)
  end

  # Classify a report as :safe or :unsafe
  defp classify_report(report) do
    if is_report_safe?(report) do
      :safe
    else
      retry_unsafe_report(report)
    end
  end

  defp is_report_safe?(report) do
    chunks = Enum.chunk_every(report, 2, 1, :discard)

    consistent_direction? = consistent_direction?(chunks)
    levels_within_range? = levels_all_within_range?(chunks)

    consistent_direction? and levels_within_range?
  end

  defp consistent_direction?(chunks) do
    increasing? = Enum.all?(chunks, fn [first, second] -> first < second end)
    decreasing? = Enum.all?(chunks, fn [first, second] -> first > second end)
    increasing? or decreasing?
  end

  defp levels_all_within_range?(chunks) do
    Enum.all?(chunks, fn
      [first, second] when first > second -> (first - second) in 1..3
      [first, second] when first < second -> (second - first) in 1..3
      _ -> false
    end)
  end

  defp retry_unsafe_report(report) do
    report_with_index = Enum.with_index(report)

    results =
      Enum.map(report_with_index, fn {_level, index} ->
        report_without_level = List.delete_at(report, index)

        is_report_safe?(report_without_level)
      end)

    case Enum.any?(results) do
      true ->
        :safe

      _ ->
        :unsafe
    end
  end
end
