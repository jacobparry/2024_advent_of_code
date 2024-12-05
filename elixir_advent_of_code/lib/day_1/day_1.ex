defmodule Day1 do
  def run do
    input =
      File.read!("lib/day_1/day_1_input.txt")
      |> String.split("\n", trim: true)

    %{left: left_list, right: right_list} =
      Enum.reduce(input, %{left: [], right: []}, fn line, acc ->
        [left, right] = String.split(line, "   ")

        acc
        |> Map.update(:left, [String.to_integer(left)], &[String.to_integer(left) | &1])
        |> Map.update(:right, [String.to_integer(right)], &[String.to_integer(right) | &1])
      end)

    sorted_right_list =
      Enum.sort(right_list, :asc)

    sorted_left_list =
      Enum.sort(left_list, :asc)

    list_length =
      length(sorted_right_list) - 1

    Enum.reduce(0..list_length, %{diff: 0, similarity: 0}, fn index, acc ->
      right_value =
        Enum.at(sorted_right_list, index)

      left_value =
        Enum.at(sorted_left_list, index)

      diff_value =
        if right_value >= left_value do
          right_value - left_value
        else
          left_value - right_value
        end

      matched_right_values = Enum.filter(sorted_right_list, fn value -> value == left_value end)

      similarity_score = left_value * length(matched_right_values)

      %{acc | diff: acc.diff + diff_value, similarity: acc.similarity + similarity_score}
    end)
  end
end
