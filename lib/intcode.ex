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
    full_opcode = intcode.code |> Enum.at(intcode.pointer)

    opcode = rem(full_opcode, 100)

    op_flags =
      div(full_opcode, 100)
      |> Stream.iterate(fn n -> div(n, 10) end)
      |> Stream.map(fn n -> rem(n, 10) end)

    arg_count =
      %{
        1 => 4,
        2 => 4,
        3 => 2,
        4 => 2,
        99 => 1
      }
      |> Map.get(opcode)

    args =
      intcode.code
      |> Enum.drop(intcode.pointer + 1)
      |> Enum.take(arg_count - 1)
      |> Enum.zip(op_flags)
      |> Enum.map(fn
        {arg, 0} -> {:position, arg}
        {arg, 1} -> {:immediate, arg}
      end)

    {
      intcode |> advance_pointer(arg_count),
      opcode,
      args
    }
  end

  defp run_operation(intcode, 1, [arg1_parameter, arg2_parameter, result_parameter]) do
    value_map =
      new_value_map()
      |> load_arg(intcode, :arg1, arg1_parameter)
      |> load_arg(intcode, :arg2, arg2_parameter)

    case value_map do
      {:error} ->
        {:error}

      {:ok, %{arg1: arg1, arg2: arg2}} ->
        {:cont, intcode |> write_to(result_parameter, arg1 + arg2)}
    end
  end

  defp run_operation(intcode, 2, [arg1_parameter, arg2_parameter, result_parameter]) do
    value_map =
      new_value_map()
      |> load_arg(intcode, :arg1, arg1_parameter)
      |> load_arg(intcode, :arg2, arg2_parameter)

    case value_map do
      {:error} ->
        {:error}

      {:ok, %{arg1: arg1, arg2: arg2}} ->
        {:cont, intcode |> write_to(result_parameter, arg1 * arg2)}
    end
  end

  defp run_operation(intcode, 3, [result_parameter]) do
    {:ok, {intcode, input}} = intcode |> consume_input()

    {:cont, intcode |> write_to(result_parameter, input)}
  end

  defp run_operation(intcode, 4, [arg_parameter]) do
    value_map =
      new_value_map()
      |> load_arg(intcode, :arg, arg_parameter)

    case value_map do
      {:error} -> {:error}
      {:ok, %{arg: arg}} -> {:cont, intcode |> write_output(arg)}
    end
  end

  defp run_operation(intcode, 99, []) do
    {:halt, intcode}
  end

  defp write_to(intcode, {:position, address}, value) do
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

  defp load_arg({:error}, _intcode, _arg_name, _address) do
    {:error}
  end

  defp load_arg({:ok, map}, intcode, arg_name, {:position, address}) do
    case Enum.at(intcode.code, address) do
      nil -> {:error}
      value -> {:ok, map |> Map.put(arg_name, value)}
    end
  end

  defp load_arg({:ok, map}, _intcode, arg_name, {:immediate, value}) do
    {:ok, map |> Map.put(arg_name, value)}
  end
end
