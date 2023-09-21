defmodule Day10Test do
  use ExUnit.Case
  doctest Advent

  describe "asteroid_map" do
    test "lists out an empty list of asteroids" do
      assert Day10.asteroid_map([
               "..",
               ".."
             ])
             |> Day10.list_asteroids() == MapSet.new()
    end

    test "lists the coordinates of a single asteroid in the first row" do
      assert Day10.asteroid_map([
               "#.",
               ".."
             ])
             |> Day10.list_asteroids() == MapSet.new([%{x: 0, y: 0}])

      assert Day10.asteroid_map([
               ".#",
               ".."
             ])
             |> Day10.list_asteroids() == MapSet.new([%{x: 1, y: 0}])
    end

    test "finds asteroids in other rows as well" do
      assert Day10.asteroid_map([
               "..",
               ".#",
               "##"
             ])
             |> Day10.list_asteroids() ==
               MapSet.new([
                 %{x: 1, y: 1},
                 %{x: 0, y: 2},
                 %{x: 1, y: 2}
               ])
    end
  end

  describe "detected_from" do
    test "detects other asteroids that aren't aligned" do
      assert Day10.asteroid_map([
               "#.",
               "..",
               "#."
             ])
             |> Day10.detected_from(0, 0) == 1

      assert Day10.asteroid_map([
               "##",
               "..",
               "#."
             ])
             |> Day10.detected_from(0, 0) == 2
    end

    test "fails to detect other asteroids if they are aligned" do
      assert Day10.asteroid_map([
               "#..",
               "##.",
               "#.#"
             ])
             |> Day10.detected_from(0, 0) == 2
    end

    test "Part 1 simple example" do
      assert Day10.asteroid_map([
               ".#..#",
               ".....",
               "#####",
               "....#",
               "...##"
             ])
             |> Day10.detected_from(3, 4) == 8
    end

    test "Part 1 bigger example 1" do
      assert Day10.asteroid_map([
               "......#.#.",
               "#..#.#....",
               "..#######.",
               ".#.#.###..",
               ".#..#.....",
               "..#....#.#",
               "#..#....#.",
               ".##.#..###",
               "##...#..#.",
               ".#....####"
             ])
             |> Day10.detected_from(5, 8) == 33
    end

    test "Part 1 bigger example 2" do
      assert Day10.asteroid_map([
               "#.#...#.#.",
               ".###....#.",
               ".#....#...",
               "##.#.#.#.#",
               "....#.#.#.",
               ".##..###.#",
               "..#...##..",
               "..##....##",
               "......#...",
               ".####.###."
             ])
             |> Day10.detected_from(1, 2) == 35
    end

    test "Part 1 bigger example 3" do
      assert Day10.asteroid_map([
               ".#..#..###",
               "####.###.#",
               "....###.#.",
               "..###.##.#",
               "##.##.#.#.",
               "....###..#",
               "..#.#..#.#",
               "#..#.#.###",
               ".##...##.#",
               ".....#.#.."
             ])
             |> Day10.detected_from(6, 3) == 41
    end

    test "Part 1 huge example" do
      assert Day10.asteroid_map([
               ".#..##.###...#######",
               "##.############..##.",
               ".#.######.########.#",
               ".###.#######.####.#.",
               "#####.##.#.##.###.##",
               "..#####..#.#########",
               "####################",
               "#.####....###.#.#.##",
               "##.#################",
               "#####.##.###..####..",
               "..######..##.#######",
               "####.##.####...##..#",
               ".#####..#.######.###",
               "##...#.##########...",
               "#.##########.#######",
               ".####.#.###.###.#.##",
               "....##.##.###..#####",
               ".#.#.###########.###",
               "#.#.#.#####.####.###",
               "###.##.####.##.#..##"
             ])
             |> Day10.detected_from(11, 13) == 210
    end
  end

  describe "best_detection_count" do
    test "Part 1 simple example" do
      assert Day10.asteroid_map([
               ".#..#",
               ".....",
               "#####",
               "....#",
               "...##"
             ])
             |> Day10.best_detection_count() == 8
    end

    test "Part 1 bigger example 1" do
      assert Day10.asteroid_map([
               "......#.#.",
               "#..#.#....",
               "..#######.",
               ".#.#.###..",
               ".#..#.....",
               "..#....#.#",
               "#..#....#.",
               ".##.#..###",
               "##...#..#.",
               ".#....####"
             ])
             |> Day10.best_detection_count() == 33
    end

    test "Part 1 bigger example 2" do
      assert Day10.asteroid_map([
               "#.#...#.#.",
               ".###....#.",
               ".#....#...",
               "##.#.#.#.#",
               "....#.#.#.",
               ".##..###.#",
               "..#...##..",
               "..##....##",
               "......#...",
               ".####.###."
             ])
             |> Day10.best_detection_count() == 35
    end

    test "Part 1 bigger example 3" do
      assert Day10.asteroid_map([
               ".#..#..###",
               "####.###.#",
               "....###.#.",
               "..###.##.#",
               "##.##.#.#.",
               "....###..#",
               "..#.#..#.#",
               "#..#.#.###",
               ".##...##.#",
               ".....#.#.."
             ])
             |> Day10.best_detection_count() == 41
    end

    test "Part 1 huge example" do
      assert Day10.asteroid_map([
               ".#..##.###...#######",
               "##.############..##.",
               ".#.######.########.#",
               ".###.#######.####.#.",
               "#####.##.#.##.###.##",
               "..#####..#.#########",
               "####################",
               "#.####....###.#.#.##",
               "##.#################",
               "#####.##.###..####..",
               "..######..##.#######",
               "####.##.####...##..#",
               ".#####..#.######.###",
               "##...#.##########...",
               "#.##########.#######",
               ".####.#.###.###.#.##",
               "....##.##.###..#####",
               ".#.#.###########.###",
               "#.#.#.#####.####.###",
               "###.##.####.##.#..##"
             ])
             |> Day10.best_detection_count() == 210
    end
  end

  describe "gcd" do
    test "returns the second number if it divides the first one" do
      assert Day10.gcd(8, 2) == 2
      assert Day10.gcd(8, 4) == 4
      assert Day10.gcd(10, 5) == 5
    end

    test "returns the first number if it divides the second one" do
      assert Day10.gcd(8, 2) == 2
      assert Day10.gcd(8, 4) == 4
      assert Day10.gcd(10, 5) == 5
    end

    test "recurses when the numbers are not multiples of each other" do
      assert Day10.gcd(6, 4) == 2
      assert Day10.gcd(8, 12) == 4
      assert Day10.gcd(10, 15) == 5
      assert Day10.gcd(100, 72) == 4
    end

    test "returns the other number if one number is zero" do
      assert Day10.gcd(0, 1) == 1
      assert Day10.gcd(0, 10) == 10
      assert Day10.gcd(17, 0) == 17
    end

    test "stays positive if either input is negative" do
      assert Day10.gcd(-4, 6) == 2
      assert Day10.gcd(4, -6) == 2
      assert Day10.gcd(-4, -6) == 2
    end
  end
end
