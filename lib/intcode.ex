defmodule Intcode do
  defstruct code: [], pointer: 0

  def execute(intcode = %Intcode{}) do
    case step(intcode) do
      {:cont, new_intcode} -> execute(new_intcode)
      {:halt, new_intcode} -> {:ok, new_intcode}
      {:error} -> {:error}
    end
  end

  def step(intcode = %Intcode{code: code, pointer: pointer}) do
    opcode = code |> Enum.at(pointer)
    run_opcode(intcode, opcode)
  end

  defp run_opcode(intcode, 1) do
    binary_op(intcode, &(&1 + &2))
  end

  defp run_opcode(intcode, 2) do
    binary_op(intcode, &(&1 * &2))
  end

  defp run_opcode(intcode, 99) do
    {:halt, intcode}
  end

  defp binary_op(intcode = %Intcode{code: code, pointer: pointer}, binary_fun) do
    [arg1_address, arg2_address, result_address] = code |> Enum.drop(pointer + 1) |> Enum.take(3)

    [arg1, arg2] = [arg1_address, arg2_address] |> Enum.map(&Enum.at(code, &1))

    case {arg1, arg2} do
      {nil, _} ->
        {:error}

      {_, nil} ->
        {:error}

      {arg1, arg2} ->
        {
          :cont,
          intcode |> write_to(result_address, binary_fun.(arg1, arg2)) |> advance_pointer(4)
        }
    end
  end

  defp write_to(intcode, address, value) do
    %Intcode{
      intcode
      | code: intcode.code |> List.replace_at(address, value)
    }
  end

  defp advance_pointer(intcode, amount) do
    %Intcode{
      intcode
      | pointer: intcode.pointer + amount
    }
  end
end
