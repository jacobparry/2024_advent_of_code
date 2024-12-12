defmodule Day7Test do
  use ExUnit.Case

  @part_1_operators [:add, :multiply]
  @part_2_operators [:add, :multiply, :concat]

  test "parse input" do
    results = Day7.parse_input(sample_input())

    assert [
             %{total: 190, values: [10, 19]},
             %{total: 3267, values: [81, 40, 27]},
             %{total: 83, values: [17, 5]},
             %{total: 156, values: [15, 6]},
             %{total: 7290, values: [6, 8, 6, 15]},
             %{total: 161_011, values: [16, 10, 13]},
             %{total: 192, values: [17, 8, 14]},
             %{total: 21037, values: [9, 7, 18, 13]},
             %{total: 292, values: [11, 6, 16, 20]}
           ] == results
  end

  test "find operator permutations" do
    results =
      Day7.find_operator_permutations(
        %{total: [21037], values: [9, 7, 18, 13]},
        @part_1_operators
      )

    assert [
             [:add, :add, :add],
             [:add, :add, :multiply],
             [:add, :multiply, :add],
             [:add, :multiply, :multiply],
             [:multiply, :add, :add],
             [:multiply, :add, :multiply],
             [:multiply, :multiply, :add],
             [:multiply, :multiply, :multiply]
           ] == results
  end

  test "all_possible_equation_results" do
    equation = %{total: [21037], values: [9, 7, 18, 13]}
    permuations = Day7.find_operator_permutations(equation, @part_1_operators)

    results = Day7.all_possible_equation_results(equation, permuations)

    assert [47, 442, 301, 3744, 94, 1053, 1147, 14742] == results
  end

  test "any_match_total" do
    equation = %{total: 3267, values: [81, 40, 27]}
    permuations = Day7.find_operator_permutations(equation, @part_1_operators)
    results = Day7.all_possible_equation_results(equation, permuations)

    assert true == Day7.any_match_total(equation, results)
  end

  test "sort_valid_equations" do
    valid_equation = %{total: 3267, values: [81, 40, 27]}
    invalid_equation = %{total: 7290, values: [6, 8, 6, 15]}

    results = Day7.sort_valid_equations([valid_equation, invalid_equation], @part_1_operators)

    assert %{valid: [valid_equation], invalid: [invalid_equation]} == results
  end

  test "sum_equations" do
    equations = [
      %{total: 190, values: [10, 19]},
      %{total: 3267, values: [81, 40, 27]},
      %{total: 292, values: [11, 6, 16, 20]}
    ]

    assert 3749 == Day7.sum_equations(equations)
  end

  test "part 1 file" do
    assert 3_312_271_365_652 == Day7.part_1_file()
  end

  test "part 1 sample" do
    equations = Day7.parse_input(sample_input())
    assert 3749 == Day7.part_1(equations)
  end

  test "part 2 sum equations" do
    equations = [
      %{total: 190, values: [10, 19]},
      %{total: 3267, values: [81, 40, 27]},
      %{total: 292, values: [11, 6, 16, 20]},
      %{total: 156, values: [15, 6]},
      %{total: 7290, values: [6, 8, 6, 15]},
      %{total: 192, values: [17, 8, 14]}
    ]

    sorted_equations = Day7.sort_valid_equations(equations, @part_2_operators)
    assert 11387 == Day7.sum_equations(sorted_equations.valid)
  end

  test "part 2 file" do
    assert 509_463_489_296_712 == Day7.part_2_file()
  end

  test "part 2 sample" do
    equations = Day7.parse_input(sample_input())
    assert 11387 == Day7.part_2(equations)
  end

  def sample_input do
    """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """
  end
end
