defmodule Day7Test do
  use ExUnit.Case
  doctest Advent

  describe "max_thruster_signal" do
    test "works for the two test programs" do
      assert Day7.max_thruster_signal(
               code: [3, 0, 3, 1, 1002, 0, 10, 2, 1, 2, 1, 3, 4, 3, 99],
               phase_settings: [1, 2, 3]
             ) == 60

      assert Day7.max_thruster_signal(
               code: [3, 0, 3, 1, 1002, 1, 10, 2, 1, 2, 0, 3, 4, 3, 99],
               phase_settings: [1, 2, 3]
             ) == 321
    end
  end

  describe "amplify" do
    # Many of these tests use two Intcode programs, one that builds a number out of its base-10 digits
    # and one that "accidentally" flips the inputs, thus just summing the inputs and multiplying by
    # 10. Both programs muiltiply one input by 10 and then output their sum. The first program multiplies
    # the first input (the phase setting) by 10, which isn't the right accumulator behavior, and leads to
    # just sum times 10. The other multiplies the second input (previous intcode's output) by 10, which
    # builds the number out of its digits

    test "works for a single amplification setting" do
      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 0, 10, 2, 1, 2, 1, 3, 4, 3, 99],
               phase_settings: [1]
             ) == 10

      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 1, 10, 2, 1, 2, 0, 3, 4, 3, 99],
               phase_settings: [1]
             ) == 1
    end

    test "works for two amplification settings" do
      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 0, 10, 2, 1, 2, 1, 3, 4, 3, 99],
               phase_settings: [1, 2]
             ) == 30

      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 1, 10, 2, 1, 2, 0, 3, 4, 3, 99],
               phase_settings: [1, 2]
             ) == 12
    end

    test "works for three amplification settings" do
      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 0, 10, 2, 1, 2, 1, 3, 4, 3, 99],
               phase_settings: [1, 2, 3]
             ) == 60

      assert Day7.amplify(
               code: [3, 0, 3, 1, 1002, 1, 10, 2, 1, 2, 0, 3, 4, 3, 99],
               phase_settings: [1, 2, 3]
             ) == 123
    end

    # The next set of examples relies on programs waiting for input.
    # A program will read two inputs (the phase setting, and then the custom input), output
    # their sum, read a third input, and then output the product of the third input and the
    # previously computed sum
    #
    # For two machines, that will look like:
    # M1: Input phase1, Input 0, Output phase1, Wait for input
    # M2: Input phase2, Input phase1, Output (phase1+phase2), Wait for input
    # M1: Input (phase1+phase2), Output phase1*(phase1+phase2), Halt
    # M2: Input phase1*(phase1+phase2), Output phase1*(phase1+phase2)^2, Halt

    test "works if the programs have to wait for input" do
      assert Day7.amplify(
               code: [3, 0, 3, 1, 1, 0, 1, 2, 4, 2, 3, 3, 2, 2, 3, 4, 4, 4, 99],
               phase_settings: [1, 2]
             ) == 9
    end

    test "works for Day 7, Part 1 examples" do
      assert Day7.amplify(
               code: [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0],
               phase_settings: [4, 3, 2, 1, 0]
             ) == 43210

      assert Day7.amplify(
               code: [
                 3,
                 23,
                 3,
                 24,
                 1002,
                 24,
                 10,
                 24,
                 1002,
                 23,
                 -1,
                 23,
                 101,
                 5,
                 23,
                 23,
                 1,
                 24,
                 23,
                 23,
                 4,
                 23,
                 99,
                 0,
                 0
               ],
               phase_settings: [0, 1, 2, 3, 4]
             ) == 54321

      assert Day7.amplify(
               code: [
                 3,
                 31,
                 3,
                 32,
                 1002,
                 32,
                 10,
                 32,
                 1001,
                 31,
                 -2,
                 31,
                 1007,
                 31,
                 0,
                 33,
                 1002,
                 33,
                 7,
                 33,
                 1,
                 33,
                 31,
                 31,
                 1,
                 32,
                 31,
                 31,
                 4,
                 31,
                 99,
                 0,
                 0,
                 0
               ],
               phase_settings: [1, 0, 4, 3, 2]
             ) == 65210
    end

    test "works for Day 7, Part 2 examples" do
      assert Day7.amplify(
               code: [
                 3,
                 26,
                 1001,
                 26,
                 -4,
                 26,
                 3,
                 27,
                 1002,
                 27,
                 2,
                 27,
                 1,
                 27,
                 26,
                 27,
                 4,
                 27,
                 1001,
                 28,
                 -1,
                 28,
                 1005,
                 28,
                 6,
                 99,
                 0,
                 0,
                 5
               ],
               phase_settings: [9, 8, 7, 6, 5]
             ) == 139_629_729

      assert Day7.amplify(
               code: [
                 3,
                 52,
                 1001,
                 52,
                 -5,
                 52,
                 3,
                 53,
                 1,
                 52,
                 56,
                 54,
                 1007,
                 54,
                 5,
                 55,
                 1005,
                 55,
                 26,
                 1001,
                 54,
                 -5,
                 54,
                 1105,
                 1,
                 12,
                 1,
                 53,
                 54,
                 53,
                 1008,
                 54,
                 0,
                 55,
                 1001,
                 55,
                 1,
                 55,
                 2,
                 53,
                 55,
                 53,
                 4,
                 53,
                 1001,
                 56,
                 -1,
                 56,
                 1005,
                 56,
                 6,
                 99,
                 0,
                 0,
                 0,
                 0,
                 10
               ],
               phase_settings: [9, 7, 8, 5, 6]
             ) == 18216
    end
  end

  describe "permutations" do
    test "returns a single empty permutation for an empty array" do
      assert Day7.permutations([]) == [[]]
    end

    test "returns one permutation when there's one item" do
      assert Day7.permutations([0]) == [[0]]
    end

    test "returns both possible permutations when there are two items" do
      assert Day7.permutations([0, 1]) == [[0, 1], [1, 0]]
    end

    test "returns all six possible permutations when there are three items" do
      assert Day7.permutations([0, 1, 2]) == [
               [0, 1, 2],
               [1, 0, 2],
               [1, 2, 0],
               [0, 2, 1],
               [2, 0, 1],
               [2, 1, 0]
             ]
    end

    test "returns a monster list of permutations when there are five elements" do
      assert Day7.permutations([0, 1, 2, 3, 4]) |> length() == 120
    end
  end
end
