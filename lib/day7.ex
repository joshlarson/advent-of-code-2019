defmodule Day7 do
  def main() do
    {:ok, content} = File.read("files/day7_input.txt")

    code =
      content
      |> String.split(",")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    IO.puts(max_thruster_signal(code: code, phase_settings: [0, 1, 2, 3, 4]))
  end

  def max_thruster_signal(code: code, phase_settings: phase_settings) do
    phase_settings
    |> permutations()
    |> Enum.map(fn settings_perm -> amplify(code: code, phase_settings: settings_perm) end)
    |> Enum.max()
  end

  def amplify(code: code, phase_settings: phase_settings) do
    [first_intcode | remaining_intcodes] =
      phase_settings |> Enum.map(fn setting -> %Intcode{code: code, input: [setting]} end)

    intcodes = [first_intcode |> Intcode.add_input([0]) | remaining_intcodes] |> execute_all()

    {:ok, result_intcode} = intcodes |> List.last()
    result_intcode.output |> List.first()
  end

  def execute_all([intcode]) do
    [intcode |> Intcode.execute()]
  end

  def execute_all([intcode0 | [intcode1 | tail_intcodes]]) do
    {:ok, executed_intcode0} = intcode0 |> Intcode.execute()

    {processed_intcode0, intcode1_with_input} = Intcode.connect(executed_intcode0, intcode1)

    [{:ok, processed_intcode0} | execute_all([intcode1_with_input | tail_intcodes])]
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
