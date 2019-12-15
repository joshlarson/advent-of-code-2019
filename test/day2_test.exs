defmodule Day2Test do
  use ExUnit.Case
  doctest Advent

  describe "step" do
    test "opcode 1 adds things together" do
      assert Day2.step([1, 0, 0, 3, 99], 0) == {:cont, [1, 0, 0, 2, 99], 4}
    end

    test "opcode 2 multiplies things together" do
      assert Day2.step([2, 3, 0, 3, 99], 0) == {:cont, [2, 3, 0, 6, 99], 4}
    end

    test "opcode 99 halts" do
      assert Day2.step([99, 3, 0, 3, 99], 0) == {:halt, [99, 3, 0, 3, 99], 0}
    end

    test "example, step 1" do
      assert Day2.step([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50], 0) ==
               {:cont, [1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 4}
    end

    test "example, step 2" do
      assert Day2.step([1, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 4) ==
               {:cont, [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8}
    end

    test "example, step 3" do
      assert Day2.step([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8) ==
               {:halt, [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], 8}
    end
  end

  describe "execute" do
    test "runs the first step" do
      assert Day2.execute([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
      assert Day2.execute([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
      assert Day2.execute([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    end

    test "executes until halted" do
      assert Day2.execute([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    test "example" do
      assert Day2.execute([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]) ==
               [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
    end
  end

  describe "execute1202" do
    test "replaces indices 1 and 2 with 12 and 2 before executing" do
      assert Day2.execute1202([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99]) ==
               [5050, 12, 2, 101, 2, 3, 11, 0, 99, 30, 40, 50, 99]
    end
  end

  describe "parse" do
    test "parses a list of integers" do
      assert Day2.parse("2,3,5,7,11") == [2, 3, 5, 7, 11]
    end

    test "works even if there's a newline" do
      assert Day2.parse("2,3,5,7,11\n") == [2, 3, 5, 7, 11]
    end
  end
end
