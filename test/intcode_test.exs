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
      {:error, _} = %Intcode{code: [1, 0, 10, 3, 99]} |> Intcode.step()
    end

    test "opcode 2 multiplies things together" do
      {:cont, intcode} = %Intcode{code: [2, 3, 0, 3, 99]} |> Intcode.step()
      assert intcode.code == [2, 3, 0, 6, 99]
    end

    test "opcode 2 advances the pointer by 4" do
      {:cont, intcode} = %Intcode{code: [2, 3, 0, 3, 99]} |> Intcode.step()
      assert intcode.pointer == 4
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
      assert intcode.pointer == 8
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
  end
end
