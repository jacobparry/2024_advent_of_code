defmodule Day5.Part1 do
  def run do
    input = File.read!("lib/day_5/day_5_input.txt")
    part_1(input)
  end

  def parse_input(input) do
    {:ok, [%{rules: rules, updates: updates}], _, _, _, _} =
      Day5.Day5Parser.parse_input(input)

    %{rules: rules, updates: updates}
  end

  def part_1(input) do
    %{rules: rules, updates: updates} = parse_input(input)

    %{valid: valid, invalid: _invalid} =
      group_updates(rules, updates)
      |> IO.inspect(label: "valid and invalid", charlists: :as_lists)

    sum_middle_values(valid)
  end

  def group_updates(rules, updates) do
    Enum.reduce(updates, %{valid: [], invalid: []}, fn update_list, acc ->
      filtered_rules =
        Enum.filter(rules, fn [x, _y] -> Enum.member?(update_list, x) end)

      if Enum.all?(filtered_rules, fn [x, y] ->
           is_valid_rule?(update_list, [x, y])
         end) do
        %{acc | valid: acc.valid ++ [update_list]}
      else
        %{acc | invalid: acc.invalid ++ [update_list]}
      end
    end)
  end

  def is_valid_rule?(update_list, [page, rule]) do
    index_page = Enum.find_index(update_list, fn z -> z == page end)
    index_rule = Enum.find_index(update_list, fn z -> z == rule end)

    case {index_page, index_rule} do
      # page or rule not found in update list, so ignore the rule
      {nil, nil} -> false
      # page not found in update list, so ignore the rule
      {nil, _} -> false
      # rule not found in update list, so ignore the rule
      {_, nil} -> true
      # page index must be less than rule index
      {x, y} -> x < y
    end
  end

  def sum_middle_values(update_lists) do
    Enum.map(update_lists, &find_middle_value/1)
    |> Enum.sum()
  end

  def find_middle_value(update_list) do
    middle_index = div(length(update_list), 2)
    Enum.at(update_list, middle_index)
  end
end
