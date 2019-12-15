defmodule Day2 do
  def main do
    {:ok, content} = File.read("files/day2_input.txt")

    content
    |> parse()
    |> execute1202()
    |> List.first()
    |> IO.puts()
  end

  def execute1202(code) do
    code
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> execute()
  end

  def execute(code) do
    execute(code, 0)
  end

  defp execute(code, index) do
    case step(code, index) do
      {:cont, new_code, new_index} -> execute(new_code, new_index)
      {:halt, new_code, _} -> new_code
    end
  end

  def step(code, index) do
    opcode = code |> Enum.at(index)
    with_opcode(code, opcode, index)
  end

  defp with_opcode(code, 1, index) do
    binary_op(code, index, &(&1 + &2))
  end

  defp with_opcode(code, 2, index) do
    binary_op(code, index, &(&1 * &2))
  end

  defp with_opcode(code, 99, index) do
    {
      :halt,
      code,
      index
    }
  end

  defp binary_op(code, index, binary_fun) do
    [arg1_index, arg2_index, result_index] = code |> Enum.drop(index + 1) |> Enum.take(3)

    [arg1, arg2] = [arg1_index, arg2_index] |> Enum.map(&Enum.at(code, &1))

    {
      :cont,
      code |> List.replace_at(result_index, binary_fun.(arg1, arg2)),
      index + 4
    }
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end
end
