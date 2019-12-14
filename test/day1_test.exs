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

  describe "total_fuel_for" do
    test "is the same if the fuel would generate no new fuel requirement" do
      assert Day1.total_fuel_for("6\n") == 0
      assert Day1.total_fuel_for("7\n") == 0
      assert Day1.total_fuel_for("8\n") == 0
      assert Day1.total_fuel_for("9\n") == 1
      assert Day1.total_fuel_for("10\n") == 1
      assert Day1.total_fuel_for("11\n") == 1
      assert Day1.total_fuel_for("14\n") == 2
      assert Day1.total_fuel_for("26\n") == 6
    end

    test "negative fuel is not a thing" do
      assert Day1.total_fuel_for("3\n") == 0
    end

    test "fuel is needed to carry more than 8 units of fuel" do
      assert Day1.total_fuel_for("33\n") == 10
    end

    test "fuel is needed for fuel that's used to carry fuel" do
      assert Day1.fuel_count_for("104\n") == 32
      assert Day1.fuel_count_for("32\n") == 8
      assert Day1.fuel_count_for("8\n") == 0
      assert Day1.total_fuel_for("104\n") == 40

      assert Day1.fuel_count_for("105\n") == 33
      assert Day1.fuel_count_for("33\n") == 9
      assert Day1.fuel_count_for("9\n") == 1
      assert Day1.total_fuel_for("105\n") == 43
    end

    test "examples" do
      assert Day1.total_fuel_for("14\n") == 2
      assert Day1.total_fuel_for("1969\n") == 966
      assert Day1.total_fuel_for("100756\n") == 50346
      assert Day1.total_fuel_for("1969\n14\n100756\n") == 51314
    end
  end
end
