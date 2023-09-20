defmodule Day2Test do
  use ExUnit.Case
  doctest Advent

  describe "execute1202" do
    test "replaces indices 1 and 2 with 12 and 2 before executing" do
      assert Day2.execute1202([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99]) ==
               {:ok, [5050]}
    end
  end

  describe "execute_with_noun_and_verb" do
    test "replaces indices 1 and 2 with the given noun and verb before executing" do
      assert Day2.execute_with_noun_and_verb(
               [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99],
               12,
               2
             ) ==
               {:ok, [5050]}

      assert Day2.execute_with_noun_and_verb(
               [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99],
               9,
               10
             ) ==
               {:ok, [3500]}

      assert Day2.execute_with_noun_and_verb(
               [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99],
               2,
               70
             ) ==
               {:ok, [3500]}
    end
  end

  describe "find_noun_and_verb" do
    test "finds the pair of noun/verb that yields a given output" do
      assert Day2.find_noun_and_verb([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99], 3500) ==
               {2, 70}

      assert Day2.find_noun_and_verb([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50, 99], 5050) ==
               {4, 8}
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
