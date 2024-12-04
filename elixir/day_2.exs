defmodule Day2 do
  def run do
    input =
      File.read!("day_2_input.txt")
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))

    # Each row is a report
    # Each report has levels
    # A report is safe if all the levels are all increasing or all decreasing
    # A report is safe if adjacent levels are at least 1 and at most 3 apart
    # A report can tolerate a single bad level

    Enum.reduce(input, %{safe: 0, unsafe: 0}, fn report, acc ->
      result =
        report
        |> Enum.map(&String.to_integer/1)
        |> is_report_safe?()
        |> IO.inspect(label: "is_report_safe?", charlists: :as_lists)

      case result do
        {:safe, _} ->
          Map.update(acc, :safe, 1, &(&1 + 1))

        {:unsafe, _} ->
          Map.update(acc, :unsafe, 1, &(&1 + 1))
      end
    end)
  end

  defp is_report_safe?(report, retries \\ 0) do
    chunks = Enum.chunk_every(report, 2, 1, :discard)

    acc = process_report(report, chunks)

    with %{direction: direction} <- acc,
         [] <- acc.bad_diff_chunks,
         [] <- acc.dup_chunks,
         true <- all_same_direction?(acc) do
      {:safe, report}
    else
      _ ->
        if retries == 0 do
          retry_unsafe_report(report, chunks)
          |> IO.inspect(label: "retry_unsafe_report", charlists: :as_lists)
        else
          {:unsafe, report}
        end
    end
  end

  defp process_report(report, chunks) do
    Enum.reduce(
      chunks,
      %{
        report: report,
        chunks: chunks,
        i_count: 0,
        d_count: 0,
        i_chunks: [],
        d_chunks: [],
        dup_count: 0,
        dup_chunks: [],
        bad_diff_count: 0,
        bad_diff_chunks: []
      },
      fn
        chunk, acc ->
          acc
          |> set_chunk_increasing_or_decreasing(chunk)
          |> set_duplicate_chunks(chunk)
          |> set_report_direction()
          |> set_bad_diff_chunks(chunk)
      end
    )
  end

  defp set_chunk_increasing_or_decreasing(acc, [first, second] = chunk) when first < second do
    Map.update(acc, :i_count, 1, &(&1 + 1))
    |> Map.update(:i_chunks, [chunk], &[chunk | &1])
  end

  defp set_chunk_increasing_or_decreasing(acc, [first, second] = chunk) when first > second do
    Map.update(acc, :d_count, 1, &(&1 + 1))
    |> Map.update(:d_chunks, [chunk], &[chunk | &1])
  end

  defp set_chunk_increasing_or_decreasing(acc, _), do: acc

  defp set_duplicate_chunks(acc, [duplicate, duplicate]) do
    Map.update(acc, :dup_count, 1, &(&1 + 1))
    |> Map.update(:dup_chunks, [duplicate, duplicate], &[duplicate, duplicate | &1])
  end

  defp set_duplicate_chunks(acc, _), do: acc

  defp set_report_direction(acc) do
    if acc.i_count > acc.d_count do
      Map.put(acc, :direction, :increasing)
    else
      Map.put(acc, :direction, :decreasing)
    end
  end

  defp set_bad_diff_chunks(%{direction: :decreasing} = acc, [first, second] = chunk)
       when first - second >= 1 and first - second <= 3 do
    acc
  end

  defp set_bad_diff_chunks(%{direction: :decreasing} = acc, [first, second] = chunk) do
    Map.update(acc, :bad_diff_count, 1, &(&1 + 1))
    |> Map.update(:bad_diff_chunks, [chunk], &[chunk | &1])
  end

  defp set_bad_diff_chunks(%{direction: :increasing} = acc, [first, second] = chunk)
       when second - first >= 1 and second - first <= 3 do
    acc
  end

  defp set_bad_diff_chunks(%{direction: :increasing} = acc, [first, second] = chunk) do
    Map.update(acc, :bad_diff_count, 1, &(&1 + 1))
    |> Map.update(:bad_diff_chunks, [chunk], &[chunk | &1])
  end

  defp set_bad_diff_chunks(acc, _), do: acc

  defp retry_unsafe_report(report, chunks) do
    acc =
      process_report(report, chunks)
      |> IO.inspect(label: "process_report", charlists: :as_lists)

    bad_direction_levels = bad_direction_levels_to_remove(acc)
    bad_duplicate_levels = bad_duplicate_levels_to_remove(acc)
    bad_diff_levels = bad_diff_levels_to_remove(acc)

    case remove_bad_level(report, bad_direction_levels ++ bad_duplicate_levels ++ bad_diff_levels) do
      {:safe, _} ->
        {:safe, report}

      {:unsafe, _} ->
        {:unsafe, report}

      {:no_bad_levels, _} ->
        IO.puts("No bad levels")
        {:unsafe, report}
    end
  end

  defp all_same_direction?(%{direction: :increasing, d_count: 0} = acc), do: true
  defp all_same_direction?(%{direction: :decreasing, i_count: 0} = acc), do: true
  defp all_same_direction?(_), do: false

  defp bad_direction_levels_to_remove(%{direction: :increasing, d_chunks: d_chunks} = acc)
       when acc.d_count >= 1 do
    d_chunks
  end

  defp bad_direction_levels_to_remove(%{direction: :decreasing, i_chunks: i_chunks} = acc)
       when acc.i_count >= 1 do
    i_chunks
  end

  defp bad_direction_levels_to_remove(_), do: []

  defp bad_duplicate_levels_to_remove(%{dup_chunks: dup_chunks} = acc) when acc.dup_count >= 1 do
    dup_chunks
  end

  defp bad_duplicate_levels_to_remove(_), do: []

  defp bad_diff_levels_to_remove(%{bad_diff_chunks: bad_diff_chunks} = acc)
       when acc.bad_diff_count >= 1 do
    bad_diff_chunks
  end

  defp bad_diff_levels_to_remove(_), do: []

  defp remove_bad_level(report, []), do: {:no_bad_levels, report}

  defp remove_bad_level(report, bad_levels) do
    bad_levels = List.flatten(bad_levels)

    results =
      Enum.map(bad_levels, fn level ->
        report_without_level = List.delete(report, level)

        is_report_safe?(report_without_level, 1)
        |> IO.inspect(label: "is_report_safe?", charlists: :as_lists)
      end)

    case Enum.find(results, fn {safe, _} -> safe == :safe end) do
      {:safe, _} = result ->
        IO.inspect(result, label: "Found safe report", charlists: :as_lists)
        result

      _ ->
        {:unsafe, report}
    end
  end

  defp all_chunks_safe_diff?(:increasing, chunks) do
    Enum.all?(chunks, fn [previous, current] ->
      current - previous >= 1 and current - previous <= 3
    end)
  end

  defp all_chunks_safe_diff?(:decreasing, chunks) do
    Enum.all?(chunks, fn [previous, current] ->
      current - previous <= -1 and current - previous >= -3
    end)
  end
end
