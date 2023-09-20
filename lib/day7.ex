defmodule Day7 do
  def main() do
    {:ok, content} = File.read("files/day7_input.txt")

    code =
      content
      |> String.split(",")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    IO.puts(max_thruster_signal(code: code, phase_settings: [0, 1, 2, 3, 4]))
    IO.puts(max_thruster_signal(code: code, phase_settings: [5, 6, 7, 8, 9]))
  end

  def max_thruster_signal(code: code, phase_settings: phase_settings) do
    phase_settings
    |> permutations()
    |> Enum.map(fn settings_perm -> amplify(code: code, phase_settings: settings_perm) end)
    |> Enum.max()
  end

  def amplify(code: code, phase_settings: phase_settings) do
    [first_intcode | remaining_intcodes] =
      phase_settings
      |> Enum.map(fn setting -> Intcode.new(code: code) |> Intcode.add_input([setting]) end)

    intcodes =
      [first_intcode |> Intcode.add_input([0]) | remaining_intcodes] |> execute_all_loop()

    {:ok, result_intcode} = intcodes |> List.last()
    result_intcode.output |> List.first()
  end

  defp execute_all_loop(intcodes) do
    result = execute_all(intcodes)

    case result |> all_are_ok?() do
      true -> result
      false -> result |> just_intcodes() |> connect_loop() |> execute_all_loop()
    end
  end

  defp execute_all([intcode]) do
    [intcode |> Intcode.execute()]
  end

  defp execute_all([intcode0 | [intcode1 | tail_intcodes]]) do
    {status0, executed_intcode0} = intcode0 |> Intcode.execute()

    {processed_intcode0, intcode1_with_input} = Intcode.connect(executed_intcode0, intcode1)

    [{status0, processed_intcode0} | execute_all([intcode1_with_input | tail_intcodes])]
  end

  defp all_are_ok?(intcode_results) do
    intcode_results |> Enum.all?(fn {status, _intcode} -> status == :ok end)
  end

  defp just_intcodes(intcode_results) do
    intcode_results |> Enum.map(fn {_status, intcode} -> intcode end)
  end

  defp connect_loop(intcodes) do
    first = List.first(intcodes)
    last = List.last(intcodes)

    {new_last, new_first} = Intcode.connect(last, first)

    intcodes
    |> List.replace_at(0, new_first)
    |> List.replace_at(Enum.count(intcodes) - 1, new_last)
  end

  def permutations([]) do
    [[]]
  end

  def permutations([head | tail]) do
    prev = permutations(tail)

    prev
    |> Enum.flat_map(fn
      perm -> 0..length(perm) |> Enum.map(fn i -> perm |> List.insert_at(i, head) end)
    end)
  end
end
