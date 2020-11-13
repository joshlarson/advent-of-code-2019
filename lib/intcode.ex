defmodule Intcode do
  defstruct code: [], pointer: 0

  def execute(code) do
    execute(code, 0)
  end

  defp execute(code, instruction_pointer) do
    case step(code, instruction_pointer) do
      {:cont, new_code, new_instruction_pointer} -> execute(new_code, new_instruction_pointer)
      {:halt, new_code, _} -> {:ok, new_code}
      {:error, _, _} -> {:error}
    end
  end

  def step(code, instruction_pointer) do
    opcode = code |> Enum.at(instruction_pointer)
    with_opcode(code, opcode, instruction_pointer)
  end

  def step(%Intcode{code: code, pointer: pointer}) do
    {symb, code, pointer} = step(code, pointer)
    {symb, %Intcode{code: code, pointer: pointer}}
  end

  defp with_opcode(code, 1, instruction_pointer) do
    binary_op(code, instruction_pointer, &(&1 + &2))
  end

  defp with_opcode(code, 2, instruction_pointer) do
    binary_op(code, instruction_pointer, &(&1 * &2))
  end

  defp with_opcode(code, 99, instruction_pointer) do
    {
      :halt,
      code,
      instruction_pointer
    }
  end

  defp binary_op(code, instruction_pointer, binary_fun) do
    [arg1_address, arg2_address, result_address] =
      code |> Enum.drop(instruction_pointer + 1) |> Enum.take(3)

    [arg1, arg2] = [arg1_address, arg2_address] |> Enum.map(&Enum.at(code, &1))

    case {arg1, arg2} do
      {nil, _} ->
        {:error, code, instruction_pointer}

      {_, nil} ->
        {:error, code, instruction_pointer}

      {arg1, arg2} ->
        {
          :cont,
          code |> List.replace_at(result_address, binary_fun.(arg1, arg2)),
          instruction_pointer + 4
        }
    end
  end
end
