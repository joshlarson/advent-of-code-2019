defmodule Day4Test do
  use ExUnit.Case
  doctest Advent

  describe "valid_password" do
    test "examples" do
      assert Day4.valid_password(111_111) == true
      assert Day4.valid_password(223_450) == false
      assert Day4.valid_password(123_789) == false
    end
  end

  describe "super_valid_password" do
    test "examples" do
      assert Day4.super_valid_password(111_111) == false
      assert Day4.super_valid_password(223_450) == false
      assert Day4.super_valid_password(123_789) == false
      assert Day4.super_valid_password(112_233) == true
      assert Day4.super_valid_password(123_444) == false
      assert Day4.super_valid_password(111_122) == true
    end
  end

  describe "has_equal_adjacent_digits" do
    test "detects trailing digits" do
      assert Day4.has_equal_adjacent_digits(123_456) == false
      assert Day4.has_equal_adjacent_digits(123_455) == true
      assert Day4.has_equal_adjacent_digits(123_466) == true
    end

    test "detects pairs of digits that aren't at the end" do
      assert Day4.has_equal_adjacent_digits(123_345) == true
    end

    test "examples" do
      assert Day4.has_equal_adjacent_digits(111_111) == true
      assert Day4.has_equal_adjacent_digits(223_450) == true
      assert Day4.has_equal_adjacent_digits(123_789) == false
    end
  end

  describe "no_decreasing_digits" do
    test "detects decreases in digits" do
      assert Day4.no_decreasing_digits(123_456) == true
      assert Day4.no_decreasing_digits(213_456) == false
    end

    test "equal digits are okay" do
      assert Day4.no_decreasing_digits(123_446) == true
    end

    test "examples" do
      assert Day4.no_decreasing_digits(111_111) == true
      assert Day4.no_decreasing_digits(223_450) == false
      assert Day4.no_decreasing_digits(123_789) == true
    end
  end

  describe "has_exactly_two_of_something" do
    test "does not rule out sets of digits if they are in sets of two" do
      assert Day4.has_exactly_two_of_something(112_233) == true
    end

    test "rules out sets of digits that are too long" do
      assert Day4.has_exactly_two_of_something(123_444) == false
    end

    test "doesn't rule out everything even if it rules out something" do
      assert Day4.has_exactly_two_of_something(111_122) == true
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
