defmodule Day4Test do
  use ExUnit.Case
  doctest Advent

  describe "valid_password" do
    test "examples" do
      assert Day4.valid_password(111111) == true
      assert Day4.valid_password(223450) == false
      assert Day4.valid_password(123789) == false
    end
  end

  describe "has_equal_adjacent_digits" do
    test "detects trailing digits" do
      assert Day4.has_equal_adjacent_digits(123456) == false
      assert Day4.has_equal_adjacent_digits(123455) == true
      assert Day4.has_equal_adjacent_digits(123466) == true
    end

    test "detects pairs of digits that aren't at the end" do
      assert Day4.has_equal_adjacent_digits(123345) == true
    end

    test "examples" do
      assert Day4.has_equal_adjacent_digits(111111) == true
      assert Day4.has_equal_adjacent_digits(223450) == true
      assert Day4.has_equal_adjacent_digits(123789) == false
    end
  end

  describe "no_decreasing_digits" do
    test "detects decreases in digits" do
      assert Day4.no_decreasing_digits(123456) == true
      assert Day4.no_decreasing_digits(213456) == false
    end

    test "equal digits are okay" do
      assert Day4.no_decreasing_digits(123446) == true
    end

    test "examples" do
      assert Day4.no_decreasing_digits(111111) == true
      assert Day4.no_decreasing_digits(223450) == false
      assert Day4.no_decreasing_digits(123789) == true
    end
  end

  describe "digits" do
    test "can digit-ize a 1 digit number" do
      assert Day4.digits(3) == [3]
    end

    test "can digit-ize a 2 digit number" do
      assert Day4.digits(45) == [4, 5]
    end

    test "can digit-ize a 3 digit number" do
      assert Day4.digits(587) == [5, 8, 7]
    end
  end
end
