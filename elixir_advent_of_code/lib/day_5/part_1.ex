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

    # |> IO.inspect(label: "valid and invalid", charlists: :as_lists)

    sum_middle_values(valid)
    |> IO.inspect(label: "sum of middle values")
  end

  def group_updates(rules, updates) do
    %{valid: valid, invalid: invalid} =
      Enum.reduce(updates, %{valid: [], invalid: []}, fn update_list, acc ->
        filtered_rules = filter_rules(rules, update_list)

        if Enum.all?(filtered_rules, fn rule ->
             is_valid_rule?(update_list, rule)
           end) do
          %{acc | valid: acc.valid ++ [update_list]}
        else
          %{acc | invalid: acc.invalid ++ [update_list]}
        end
      end)

    %{valid: Enum.count(valid), invalid: Enum.count(invalid)}
    |> IO.inspect(label: "valid and invalid counts")

    %{valid: valid, invalid: invalid}
  end

  def filter_rules(rules, update_list) do
    # I only care about rules where both parts are present
    # Rules that don't have both parts don't apply

    Enum.filter(rules, fn [x, y] ->
      Enum.member?(update_list, x) and Enum.member?(update_list, y)
    end)
  end

  def is_valid_rule?(update_list, [page, rule]) do
    IO.inspect(update_list, label: "update_list", charlists: :as_lists)
    IO.inspect([page, rule], label: "page and rule", charlists: :as_lists)
    index_page = Enum.find_index(update_list, fn z -> z == page end)
    index_rule = Enum.find_index(update_list, fn z -> z == rule end)

    IO.inspect({index_page, index_rule}, label: "index_page and index_rule")

    index_page < index_rule
  end

  def sum_middle_values(update_lists) do
    Enum.reduce(update_lists, 0, fn update_list, acc ->
      acc + find_middle_value(update_list)
    end)
  end

  def find_middle_value(update_list) do
    # -1 because the list is 0-indexed
    middle_index = div(length(update_list) - 1, 2)
    Enum.at(update_list, middle_index)
  end
end
