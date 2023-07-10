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
    amplify_helper(code: code, phase_settings: phase_settings, signal: 0)
  end

  defp amplify_helper(code: _code, phase_settings: [], signal: signal) do
    signal
  end

  defp amplify_helper(code: code, phase_settings: [setting | rest_of_settings], signal: input_signal) do
    {:ok, intcode} = %Intcode{code: code, input: [setting, input_signal]} |> Intcode.execute()

    [output_signal | _] = intcode.output

    amplify_helper(code: code, phase_settings: rest_of_settings, signal: output_signal)
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
