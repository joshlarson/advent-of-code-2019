defmodule Intcode do
  defstruct memory: %{}, pointer: 0, input: [], output: []

  def new(args) do
    defaults = [pointer: 0, output: []]

    %{code: code, pointer: pointer, output: output} =
      Keyword.merge(defaults, args) |> Enum.into(%{})

    memory =
      code
      |> Enum.with_index()
      |> Enum.map(fn {value, index} -> {index, value} end)
      |> Map.new()

    %Intcode{memory: memory, pointer: pointer, output: output}
  end

  def code(%Intcode{memory: memory}, length) do
    0..(length - 1)
    |> Enum.map(fn i ->
      case memory do
        %{^i => v} -> v
        %{} -> 0
      end
    end)
  end

  def execute(intcode) do
    case step(intcode) do
      {:cont, new_intcode} -> execute(new_intcode)
      {:halt, new_intcode} -> {:ok, new_intcode}
      {:wait, new_intcode} -> {:waiting, new_intcode}
      {:error} -> {:error}
    end
  end

  def step(intcode) do
    {new_intcode, opcode, args} = read_args(intcode)
    run_operation(new_intcode, opcode, args)
  end

  def add_input(intcode = %Intcode{input: existing_input}, new_input) do
    %Intcode{intcode | input: existing_input ++ new_input}
  end

  def clear_output(intcode) do
    %Intcode{intcode | output: []}
  end

  def connect(src_intcode = %Intcode{output: signal}, dst_intcode) do
    {
      src_intcode |> clear_output,
      dst_intcode |> add_input(Enum.reverse(signal))
    }
  end

  defp read_args(intcode) do
    full_opcode = intcode |> memory_at(intcode.pointer)

    opcode = rem(full_opcode, 100)

    op_flags =
      div(full_opcode, 100)
      |> Stream.iterate(fn n -> div(n, 10) end)
      |> Stream.map(fn n -> rem(n, 10) end)

    arg_count =
      %{
        1 => 3,
        2 => 3,
        3 => 1,
        4 => 1,
        5 => 2,
        6 => 2,
        7 => 3,
        8 => 3,
        99 => 0
      }
      |> Map.get(opcode)

    arg_addresses =
      case arg_count do
        0 -> []
        _ -> (intcode.pointer + 1)..(intcode.pointer + arg_count)
      end

    args =
      arg_addresses
      |> Enum.map(fn i -> intcode |> memory_at(i) end)
      |> Enum.zip(op_flags)
      |> Enum.map(fn
        {arg, 0} -> {:position, arg}
        {arg, 1} -> {:immediate, arg}
      end)

    {
      intcode |> advance_pointer(arg_count + 1),
      opcode,
      args
    }
  end

  defp run_operation(intcode, 1, [arg1_parameter, arg2_parameter, result_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg1, arg1_parameter)
    |> load_arg(intcode, :arg2, arg2_parameter)
    |> evaluate(fn %{arg1: arg1, arg2: arg2} ->
      intcode |> write_to(result_parameter, arg1 + arg2)
    end)
  end

  defp run_operation(intcode, 2, [arg1_parameter, arg2_parameter, result_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg1, arg1_parameter)
    |> load_arg(intcode, :arg2, arg2_parameter)
    |> evaluate(fn %{arg1: arg1, arg2: arg2} ->
      intcode |> write_to(result_parameter, arg1 * arg2)
    end)
  end

  defp run_operation(intcode, 3, [result_parameter]) do
    case intcode |> consume_input() do
      {:ok, {new_intcode, input}} -> {:cont, new_intcode |> write_to(result_parameter, input)}
      # Retracting the pointer is a hack to accomodate the fact that under normal operation, the
      # pointer is advanced before the command is run.
      {:error} -> {:wait, intcode |> advance_pointer(-2)}
    end
  end

  defp run_operation(intcode, 4, [arg_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg, arg_parameter)
    |> evaluate(fn %{arg: arg} -> intcode |> write_output(arg) end)
  end

  defp run_operation(intcode, 5, [arg_parameter, jump_to_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg, arg_parameter)
    |> load_arg(intcode, :jump_to, jump_to_parameter)
    |> evaluate(fn
      %{arg: 0} -> intcode
      %{jump_to: jump_to} -> intcode |> jump_to(jump_to)
    end)
  end

  defp run_operation(intcode, 6, [arg_parameter, jump_to_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg, arg_parameter)
    |> load_arg(intcode, :jump_to, jump_to_parameter)
    |> evaluate(fn
      %{arg: 0, jump_to: jump_to} -> intcode |> jump_to(jump_to)
      %{} -> intcode
    end)
  end

  defp run_operation(intcode, 7, [arg1_parameter, arg2_parameter, result_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg1, arg1_parameter)
    |> load_arg(intcode, :arg2, arg2_parameter)
    |> evaluate(fn
      %{arg1: arg1, arg2: arg2} when arg1 < arg2 ->
        intcode |> write_to(result_parameter, 1)

      %{} ->
        intcode |> write_to(result_parameter, 0)
    end)
  end

  defp run_operation(intcode, 8, [arg1_parameter, arg2_parameter, result_parameter]) do
    new_value_map()
    |> load_arg(intcode, :arg1, arg1_parameter)
    |> load_arg(intcode, :arg2, arg2_parameter)
    |> evaluate(fn
      %{arg1: arg1, arg2: arg2} when arg1 == arg2 ->
        intcode |> write_to(result_parameter, 1)

      %{} ->
        intcode |> write_to(result_parameter, 0)
    end)
  end

  defp run_operation(intcode, 99, []) do
    # Retracting the pointer is a hack to accomodate the fact that under normal operation, the
    # pointer is advanced before the command is run.
    {:halt, intcode |> advance_pointer(-1)}
  end

  defp write_to(intcode, {:position, address}, value) do
    %Intcode{
      intcode
      | memory: intcode.memory |> Map.put(address, value)
    }
  end

  defp advance_pointer(intcode, amount) do
    %Intcode{
      intcode
      | pointer: intcode.pointer + amount
    }
  end

  defp jump_to(intcode, new_location) do
    %Intcode{intcode | pointer: new_location}
  end

  defp consume_input(%Intcode{input: []}) do
    {:error}
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
    value = intcode |> memory_at(address)

    {:ok, map |> Map.put(arg_name, value)}
  end

  defp load_arg({:ok, map}, _intcode, arg_name, {:immediate, value}) do
    {:ok, map |> Map.put(arg_name, value)}
  end

  defp memory_at(%Intcode{memory: memory}, address) do
    case memory do
      %{^address => value} -> value
      %{} -> 0
    end
  end

  defp evaluate({:error}, _func) do
    {:error}
  end

  defp evaluate({:ok, map}, func) do
    {:cont, func.(map)}
  end
end
