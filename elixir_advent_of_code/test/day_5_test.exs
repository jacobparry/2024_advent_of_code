defmodule Day5Test do
  use ExUnit.Case

  test "parse_input" do
    sample_input =
      """
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
      """

    assert Day5.Day5Parser.parse_input(sample_input) ==
             {:ok,
              [
                %{
                  rules: [
                    [47, 53],
                    [97, 13],
                    [97, 61],
                    [97, 47],
                    [75, 29],
                    [61, 13],
                    [75, 53],
                    [29, 13],
                    [97, 29],
                    [53, 29],
                    [61, 53],
                    [97, 53],
                    [61, 29],
                    [47, 13],
                    [75, 47],
                    [97, 75],
                    [47, 61],
                    [75, 61],
                    [47, 29],
                    [75, 13],
                    [53, 13]
                  ],
                  updates: [
                    [75, 47, 61, 53, 29],
                    [97, 61, 53, 29, 13],
                    [75, 29, 13],
                    [75, 97, 47, 61, 53],
                    [61, 13, 29],
                    [97, 13, 75, 29, 47]
                  ]
                }
              ], "", %{}, {29, 205}, 205}

    %{rules: rules, updates: updates} = Day5.Part1.parse_input(sample_input)

    %{valid: valid, invalid: _invalid} =
      Day5.Part1.group_updates(rules, updates)

    assert Day5.Part1.sum_middle_values(valid) == 143

    assert Day5.Part1.run() == 4689

    update_list = [75, 47, 61, 53, 29]
    assert Day5.Part1.find_middle_value(update_list) == 61
  end

  test "part 2" do
    sample_input =
      """
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
      """

    %{rules: rules, updates: updates} = Day5.Part2.parse_input(sample_input)

    %{valid: _valid, invalid: invalid} =
      Day5.Part2.group_updates(rules, updates)

    assert Day5.Part2.group_rules(rules) ==
             %{
               29 => [13],
               47 => [13, 29, 53, 61],
               53 => [13, 29],
               61 => [13, 29, 53],
               75 => [13, 29, 47, 53, 61],
               97 => [13, 29, 47, 53, 61, 75]
             }

    assert Day5.Part2.fix_invalid_updates(rules, invalid) == [
             [97, 75, 47, 61, 53],
             [61, 29, 13],
             [97, 75, 47, 29, 13]
           ]

    assert Day5.Part2.run() == 6336
  end
end
