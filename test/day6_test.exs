defmodule Day6Test do
  use ExUnit.Case
  doctest Advent

  describe "orbit_count" do
    test "works when there is one orbit" do
      orbits = Day6.orbit_map(["COM)B"])
      assert orbits |> Day6.orbit_count("B") == 1
      assert orbits |> Day6.orbit_count("COM") == 0
    end

    test "works when there are two things orbiting the center of mass" do
      orbits = Day6.orbit_map(["COM)B", "COM)C"])
      assert orbits |> Day6.orbit_count("B") == 1
      assert orbits |> Day6.orbit_count("C") == 1
      assert orbits |> Day6.orbit_count("COM") == 0
    end

    test "works when there are indirect orbits" do
      orbits = Day6.orbit_map(["COM)B", "B)C"])
      assert orbits |> Day6.orbit_count("B") == 1
      assert orbits |> Day6.orbit_count("C") == 2
      assert orbits |> Day6.orbit_count("COM") == 0
    end

    test "example input" do
      orbits =
        Day6.orbit_map([
          "COM)B",
          "B)C",
          "C)D",
          "D)E",
          "E)F",
          "B)G",
          "G)H",
          "D)I",
          "E)J",
          "J)K",
          "K)L"
        ])

      assert orbits |> Day6.orbit_count("D") == 3
      assert orbits |> Day6.orbit_count("L") == 7
      assert orbits |> Day6.orbit_count("COM") == 0
    end
  end

  describe "full_orbit_count" do
    test "works when there is one orbit" do
      orbits = Day6.orbit_map(["COM)B"])
      assert orbits |> Day6.full_orbit_count() == 1
    end

    test "works when there are two things orbiting the center of mass" do
      orbits = Day6.orbit_map(["COM)B", "COM)C"])
      assert orbits |> Day6.full_orbit_count() == 2
    end

    test "works when there are indirect orbits" do
      orbits = Day6.orbit_map(["COM)B", "B)C"])
      assert orbits |> Day6.full_orbit_count() == 3
    end

    test "example input" do
      orbits =
        Day6.orbit_map([
          "COM)B",
          "B)C",
          "C)D",
          "D)E",
          "E)F",
          "B)G",
          "G)H",
          "D)I",
          "E)J",
          "J)K",
          "K)L"
        ])

      assert orbits |> Day6.full_orbit_count() == 42
    end
  end
end
