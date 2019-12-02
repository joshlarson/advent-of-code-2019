defmodule Day1Test do
  use ExUnit.Case
  doctest Advent

  describe "fuel_count_for" do
    test "divides by 3 and subtracts 2 for a single item" do
      assert Day1.fuel_count_for("12\n") == 2
      assert Day1.fuel_count_for("14\n") == 2
      assert Day1.fuel_count_for("1969\n") == 654
      assert Day1.fuel_count_for("100756\n") == 33583
    end

    test "adds the fuel loads together for multiple modules" do
      assert Day1.fuel_count_for("12\n1969\n") == 656
    end
  end
end
