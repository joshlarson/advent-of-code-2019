defmodule Day2Test do
  use ExUnit.Case
  doctest Advent

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
