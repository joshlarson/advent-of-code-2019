defmodule IntcodeTest do
  use ExUnit.Case
  doctest Advent

  describe "step" do
    test "opcode 1 adds things together" do
      assert Intcode.step([1, 0, 0, 3, 99], 0) == {:cont, [1, 0, 0, 2, 99], 4}
    end

    test "opcode 1 errors if there's a buffer overrun" do
      assert Intcode.step([1, 0, 10, 3, 99], 0) == {:error, [1, 0, 10, 3, 99], 0}
    end

    test "opcode 2 multiplies things together" do
      assert Intcode.step([2, 3, 0, 3, 99], 0) == {:cont, [2, 3, 0, 6, 99], 4}
    end

    test "opcode 99 halts" do
      assert Intcode.step([99, 3, 0, 3, 99], 0) == {:halt, [99, 3, 0, 3, 99], 0}
    end

    test "example, step 1" do
      assert Intcode.step([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50], 0) ==
               {:cont, [1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 4}
    end

    test "example, step 2" do
      assert Intcode.step([1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 4) ==
               {:cont, [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8}
    end

    test "example, step 3" do
      assert Intcode.step([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8) ==
               {:halt, [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8}
    end
  end

  describe "execute" do
    test "runs the first step" do
      assert Intcode.execute([1, 0, 0, 0, 99]) == {:ok, [2, 0, 0, 0, 99]}
      assert Intcode.execute([2, 3, 0, 3, 99]) == {:ok, [2, 3, 0, 6, 99]}
      assert Intcode.execute([2, 4, 4, 5, 99, 0]) == {:ok, [2, 4, 4, 5, 99, 9801]}
    end

    test "executes until halted" do
      assert Intcode.execute([1, 1, 1, 4, 99, 5, 6, 0, 99]) ==
               {:ok, [30, 1, 1, 4, 2, 5, 6, 0, 99]}
    end

    test "returns an error if necessary" do
      assert Intcode.execute([1, 0, 10, 3, 99]) == {:error}
    end

    test "example from Day 2" do
      assert Intcode.execute([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]) ==
               {:ok, [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]}
    end
  end
end