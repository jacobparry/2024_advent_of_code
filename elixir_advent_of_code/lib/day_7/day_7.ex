defmodule Day7 do
  def run_file do
    input = File.read!("lib/day_7/day_7_input.txt")

    parse_input(input)
  end

  def run_sample(input) do
    parse_input(input)
  end

  def parse_input(input) do
    {:ok, equations, _, _, _, _} = Day7.Day7Parser.parse_input(input)

    equations
  end

  def part_1_file do
    _start_time = DateTime.utc_now()
    equations = run_file()
    results = part_1(equations)
    _end_time = DateTime.utc_now()
    # IO.inspect(DateTime.diff(end_time, start_time, :millisecond))
    results
  end

  def part_1(equations) do
    part_1_operators = [:add, :multiply]

    sorted_equations = sort_valid_equations(equations, part_1_operators)

    sum_equations(sorted_equations.valid)
  end

  def part_2_file do
    _start_time = DateTime.utc_now()
    equations = run_file()
    results = part_2(equations)
    _end_time = DateTime.utc_now()
    # IO.inspect(DateTime.diff(end_time, start_time, :millisecond))
    results
  end

  def part_2(equations) do
    part_2_operators = [:add, :multiply, :concat]

    sorted_equations = sort_valid_equations(equations, part_2_operators)

    sum_equations(sorted_equations.valid)
  end

  def sort_valid_equations(equations, operators) do
    Enum.reduce(equations, %{valid: [], invalid: []}, fn equation, acc ->
      operator_permutations = find_operator_permutations(equation, operators)
      equation_results = all_possible_equation_results(equation, operator_permutations)

      if any_match_total(equation, equation_results) do
        Map.put(acc, :valid, [equation | acc.valid])
      else
        Map.put(acc, :invalid, [equation | acc.invalid])
      end
    end)
  end

  def sum_equations(equations) do
    Enum.reduce(equations, 0, fn %{total: total}, acc ->
      acc + total
    end)
  end

  def any_match_total(%{total: total} = _equation, equation_results) do
    Enum.any?(equation_results, fn result ->
      result == total
    end)
  end

  def find_operator_permutations(%{total: _, values: values} = _equation, operators) do
    positions = length(values) - 1

    Enum.reduce(1..positions, [[]], fn _, acc ->
      for combination <- acc, operator <- operators do
        combination ++ [operator]
      end
    end)
  end

  def all_possible_equation_results(%{values: values} = _equation, operator_permutations) do
    Enum.map(operator_permutations, fn operators ->
      apply_operators(values, operators)
    end)
  end

  def apply_operators([head | tail], operators) do
    paired_values = Enum.zip(tail, operators)

    Enum.reduce(paired_values, head, fn {value, operator}, acc ->
      apply_operator(acc, value, operator)
    end)
  end

  def apply_operator(a, b, :add), do: a + b
  def apply_operator(a, b, :multiply), do: a * b

  def apply_operator(a, b, :concat) do
    (Integer.to_string(a) <> Integer.to_string(b))
    |> String.to_integer()
  end
end
