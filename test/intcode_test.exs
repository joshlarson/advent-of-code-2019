defmodule IntcodeTest do
  use ExUnit.Case
  doctest Advent

  describe "step" do
    test "opcode 1 adds things together" do
      {:cont, intcode} = %Intcode{code: [1, 0, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [1, 0, 0, 2, 99]
    end

    test "opcode 1 advances the pointer by 4" do
      {:cont, intcode} = %Intcode{code: [1, 0, 0, 3, 99]} |> Intcode.step()
      assert intcode.pointer == 4
    end

    test "opcode 1 errors if there's a buffer overrun" do
      {:error} = %Intcode{code: [1, 0, 10, 3, 99]} |> Intcode.step()
    end

    test "opcode 1 with immediate mode on the first arg adds things together" do
      {:cont, intcode} = %Intcode{code: [101, 0, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [101, 0, 0, 101, 99]
    end

    test "opcode 1 with immediate mode on the second arg adds things together" do
      {:cont, intcode} = %Intcode{code: [1001, 0, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [1001, 0, 0, 1001, 99]
    end

    test "opcode 1 with immediate mode on both args adds things together" do
      {:cont, intcode} = %Intcode{code: [1101, 0, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [1101, 0, 0, 0, 99]
    end

    test "opcode 2 multiplies things together" do
      {:cont, intcode} = %Intcode{code: [2, 3, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [2, 3, 0, 6, 99]
    end

    test "opcode 2 advances the pointer by 4" do
      {:cont, intcode} = %Intcode{code: [2, 3, 0, 3, 99]} |> Intcode.step()
      assert intcode.pointer == 4
    end

    test "opcode 2 works with immediate mode" do
      {:cont, intcode} = %Intcode{code: [1002, 4, 3, 4, 33]} |> Intcode.step()
      assert intcode.code == [1002, 4, 3, 4, 99]
    end

    test "opcode 3 stores an input argument" do
      {:cont, intcode} = %Intcode{code: [3, 1, 99], input: [100]} |> Intcode.step()
      assert intcode.code == [3, 100, 99]
    end

    test "opcode 3 consumes its input argument" do
      {:cont, intcode} = %Intcode{code: [3, 1, 99], input: [100]} |> Intcode.step()
      assert intcode.input == []
    end

    test "opcode 3 only consumes one input argument" do
      {:cont, intcode} = %Intcode{code: [3, 1, 99], input: [100, 50]} |> Intcode.step()
      assert intcode.input == [50]
    end

    test "opcode 3 advances the pointer by 2" do
      {:cont, intcode} = %Intcode{code: [3, 1, 99], input: [100]} |> Intcode.step()
      assert intcode.pointer == 2
    end

    test "opcode 4 writes a value to the output" do
      {:cont, intcode} = %Intcode{code: [4, 2, 99]} |> Intcode.step()
      assert intcode.output == [99]
    end

    test "opcode 4 preserves the original intcode" do
      {:cont, intcode} = %Intcode{code: [4, 2, 99]} |> Intcode.step()
      assert intcode.code == [4, 2, 99]
    end

    test "opcode 4 advances the pointer by 2" do
      {:cont, intcode} = %Intcode{code: [4, 2, 99]} |> Intcode.step()
      assert intcode.output == [99]
    end

    test "opcode 5 jumps if its argument is non-zero" do
      {:cont, intcode} = %Intcode{code: [1105, 2, 4, 99, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [1105, 2, 4, 99, 99]
    end

    test "opcode 5 does not jump (but does advance) if its argument is zero" do
      {:cont, intcode} = %Intcode{code: [1105, 0, 4, 99, 99]} |> Intcode.step()
      assert intcode.pointer == 3
      assert intcode.code == [1105, 0, 4, 99, 99]
    end

    test "opcode 6 jumps if its argument is zero" do
      {:cont, intcode} = %Intcode{code: [1106, 0, 4, 99, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [1106, 0, 4, 99, 99]
    end

    test "opcode 6 does not jump (but does advance) if its argument is non-zero" do
      {:cont, intcode} = %Intcode{code: [1106, 2, 4, 99, 99]} |> Intcode.step()
      assert intcode.pointer == 3
      assert intcode.code == [1106, 2, 4, 99, 99]
    end

    test "opcode 7 stores 1 if the first parameter is less than the second" do
      {:cont, intcode} = %Intcode{code: [1107, 2, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [1, 2, 3, 0, 99]
    end

    test "opcode 7 stores 0 if the first parameter is equal to the second" do
      {:cont, intcode} = %Intcode{code: [1107, 3, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [0, 3, 3, 0, 99]
    end

    test "opcode 7 stores 0 if the first parameter is greater than the second" do
      {:cont, intcode} = %Intcode{code: [1107, 4, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [0, 4, 3, 0, 99]
    end

    test "opcode 8 stores 0 if the first parameter is less than the second" do
      {:cont, intcode} = %Intcode{code: [1108, 2, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [0, 2, 3, 0, 99]
    end

    test "opcode 8 stores 1 if the first parameter is equal to the second" do
      {:cont, intcode} = %Intcode{code: [1108, 3, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [1, 3, 3, 0, 99]
    end

    test "opcode 8 stores 0 if the first parameter is greater than the second" do
      {:cont, intcode} = %Intcode{code: [1108, 4, 3, 0, 99]} |> Intcode.step()
      assert intcode.pointer == 4
      assert intcode.code == [0, 4, 3, 0, 99]
    end

    test "opcode 99 halts" do
      {:halt, intcode} = %Intcode{code: [99, 3, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [99, 3, 0, 3, 99]
    end

    test "example, step 1" do
      {:cont, intcode} =
        %Intcode{code: [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]} |> Intcode.step()

      assert intcode.code == [1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
      assert intcode.pointer == 4
    end

    test "example, step 2" do
      {:cont, intcode} =
        %Intcode{code: [1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], pointer: 4} |> Intcode.step()

      assert intcode.code == [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
      assert intcode.pointer == 8
    end

    test "example, step 3" do
      {:halt, intcode} =
        %Intcode{code: [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], pointer: 8}
        |> Intcode.step()

      assert intcode.code == [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
      assert intcode.pointer == 9
    end
  end

  describe "execute" do
    test "runs the first step when the second step is halt" do
      {:ok, intcode} = %Intcode{code: [1, 0, 0, 0, 99]} |> Intcode.execute()
      assert intcode.code == [2, 0, 0, 0, 99]

      {:ok, intcode} = %Intcode{code: [2, 3, 0, 3, 99]} |> Intcode.execute()
      assert intcode.code == [2, 3, 0, 6, 99]

      {:ok, intcode} = %Intcode{code: [2, 4, 4, 5, 99, 0]} |> Intcode.execute()
      assert intcode.code == [2, 4, 4, 5, 99, 9801]
    end

    test "executes until halted" do
      {:ok, intcode} = %Intcode{code: [1, 1, 1, 4, 99, 5, 6, 0, 99]} |> Intcode.execute()
      assert intcode.code == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "returns an error if necessary" do
      assert %Intcode{code: [1, 0, 10, 3, 99]} |> Intcode.execute() == {:error}
    end

    test "example from Day 2" do
      {:ok, intcode} =
        %Intcode{code: [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]} |> Intcode.execute()

      assert intcode.code == [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
    end

    test "input example" do
      {:ok, intcode} =
        %Intcode{code: [3, 5, 3, 4, 5, 0, 6], input: [6, 3, 99, 17]} |> Intcode.execute()

      assert intcode.code == [3, 5, 3, 4, 3, 6, 99]
      assert intcode.input == [17]
      assert intcode.output == []
    end

    test "output example" do
      {:ok, intcode} =
        %Intcode{code: [4, 12, 3, 0, 3, 1, 2, 0, 1, 12, 4, 12, 42], input: [3, 33]}
        |> Intcode.execute()

      assert intcode.code == [3, 33, 3, 0, 3, 1, 2, 0, 1, 12, 4, 12, 99]
      assert intcode.input == []
      assert intcode.output == [99, 42]
    end

    test "Day 5 example, equals, position mode" do
      code = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
      {:ok, intcode} = %Intcode{code: code, input: [7]} |> Intcode.execute()
      assert intcode.output == [0]
      {:ok, intcode} = %Intcode{code: code, input: [8]} |> Intcode.execute()
      assert intcode.output == [1]
      {:ok, intcode} = %Intcode{code: code, input: [9]} |> Intcode.execute()
      assert intcode.output == [0]
    end

    test "Day 5 example, less than, position mode" do
      code = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
      {:ok, intcode} = %Intcode{code: code, input: [7]} |> Intcode.execute()
      assert intcode.output == [1]
      {:ok, intcode} = %Intcode{code: code, input: [8]} |> Intcode.execute()
      assert intcode.output == [0]
      {:ok, intcode} = %Intcode{code: code, input: [9]} |> Intcode.execute()
      assert intcode.output == [0]
    end

    test "Day 5 example, equals, immediate mode" do
      code = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
      {:ok, intcode} = %Intcode{code: code, input: [7]} |> Intcode.execute()
      assert intcode.output == [0]
      {:ok, intcode} = %Intcode{code: code, input: [8]} |> Intcode.execute()
      assert intcode.output == [1]
      {:ok, intcode} = %Intcode{code: code, input: [9]} |> Intcode.execute()
      assert intcode.output == [0]
    end

    test "Day 5 example, less than, immediate mode" do
      code = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
      {:ok, intcode} = %Intcode{code: code, input: [7]} |> Intcode.execute()
      assert intcode.output == [1]
      {:ok, intcode} = %Intcode{code: code, input: [8]} |> Intcode.execute()
      assert intcode.output == [0]
      {:ok, intcode} = %Intcode{code: code, input: [9]} |> Intcode.execute()
      assert intcode.output == [0]
    end
  end
end
