defmodule Intcode do
  defstruct code: [], pointer: 0, input: [], output: []

  def execute(intcode) do
    case step(intcode) do
      {:cont, new_intcode} -> execute(new_intcode)
      {:halt, new_intcode} -> {:ok, new_intcode}
      {:error} -> {:error}
    end
  end

  def step(intcode) do
    {new_intcode, opcode, args} = read_args(intcode)
    run_operation(new_intcode, opcode, args)
  end

  defp read_args(intcode) do
    opcode = intcode.code |> Enum.at(intcode.pointer)

    arg_count =
      %{
        1 => 4,
        2 => 4,
        3 => 2,
        4 => 2,
        99 => 1
      }
      |> Map.get(opcode)

    {
      intcode |> advance_pointer(arg_count),
      opcode,
      intcode.code |> Enum.drop(intcode.pointer + 1) |> Enum.take(arg_count - 1)
    }
  end

  defp run_operation(intcode, 1, [arg1_address, arg2_address, result_address]) do
    value_map =
      new_value_map()
      |> load_from_address(intcode, :arg1, arg1_address)
      |> load_from_address(intcode, :arg2, arg2_address)

    case value_map do
      {:error} ->
        {:error}

      {:ok, %{arg1: arg1, arg2: arg2}} ->
        {:cont, intcode |> write_to(result_address, arg1 + arg2)}
    end
  end

  defp run_operation(intcode, 2, [arg1_address, arg2_address, result_address]) do
    value_map =
      new_value_map()
      |> load_from_address(intcode, :arg1, arg1_address)
      |> load_from_address(intcode, :arg2, arg2_address)

    case value_map do
      {:error} ->
        {:error}

      {:ok, %{arg1: arg1, arg2: arg2}} ->
        {:cont, intcode |> write_to(result_address, arg1 * arg2)}
    end
  end

  defp run_operation(intcode, 3, [result_address]) do
    {:ok, {intcode, input}} = intcode |> consume_input()

    {:cont, intcode |> write_to(result_address, input)}
  end

  defp run_operation(intcode, 4, [arg_address]) do
    value_map =
      new_value_map()
      |> load_from_address(intcode, :arg, arg_address)

    case value_map do
      {:error} -> {:error}
      {:ok, %{arg: arg}} -> {:cont, intcode |> write_output(arg)}
    end
  end

  defp run_operation(intcode, 99, []) do
    {:halt, intcode}
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

  defp consume_input(intcode = %Intcode{input: [first | rest]}) do
    {:ok, {%Intcode{intcode | input: rest}, first}}
  end

  defp write_output(intcode = %Intcode{output: output}, value) do
    %Intcode{intcode | output: [value | output]}
  end

  defp new_value_map() do
    {:ok, %{}}
  end

  defp load_from_address({:error}, _intcode, _arg_name, _address) do
    {:error}
  end

  defp load_from_address({:ok, map}, intcode, arg_name, address) do
    case Enum.at(intcode.code, address) do
      nil -> {:error}
      value -> {:ok, map |> Map.put(arg_name, value)}
    end
  end
end
