defmodule Day3Test do
  use ExUnit.Case
  doctest Advent

  describe "build_path" do
    test "includes the first step/s along the path" do
      assert Day3.build_path("R1") |> Day3.wire_includes?({1, 0}) == true
    end

    test "does not include steps that are too far" do
      assert Day3.build_path("R1") |> Day3.wire_includes?({2, 0}) == false
    end

    test "does include steps that are farther if the path was longer" do
      assert Day3.build_path("R2") |> Day3.wire_includes?({2, 0}) == true
    end

    test "can have more than one leg" do
      assert Day3.build_path("R2,R1") |> Day3.wire_includes?({3, 0}) == true
      assert Day3.build_path("R2,R1") |> Day3.wire_includes?({2, 1}) == false
    end

    test "can turn" do
      assert Day3.build_path("R2,U1") |> Day3.wire_includes?({3, 0}) == false
      assert Day3.build_path("R2,U1") |> Day3.wire_includes?({2, 1}) == true
      assert Day3.build_path("R2,U2,L1,D1") |> Day3.wire_includes?({1, 2}) == true
      assert Day3.build_path("R2,U2,L1,D1") |> Day3.wire_includes?({1, 1}) == true
    end
  end

  describe "find_intersections" do
    test "includes only points that are in more than one path" do
      assert Day3.find_intersections("R2\nD2,R2,U2\n") |> Day3.includes_intersection?({0, 2}) == false
      assert Day3.find_intersections("R2\nD2,R2,U2\n") |> Day3.includes_intersection?({1, 0}) == false
      assert Day3.find_intersections("R2\nD2,R2,U2\n") |> Day3.includes_intersection?({2, 0}) == true
    end

    test "does not include {0, 0}" do
      assert Day3.find_intersections("R1\nD1,R1,U1\n") |> Day3.includes_intersection?({0, 0}) == false
    end
  end

  describe "closest_intersection" do
    test "works for this example" do
      assert Day3.closest_intersection_distance("R2\nD2,R2,U2\n")  == 2
    end

    test "works with a negative coordinate" do
      assert Day3.closest_intersection_distance("L2\nD2,L2,U2\n")  == 2
    end

    test "works for example 1" do
      assert Day3.closest_intersection_distance("R8,U5,L5,D3\nU7,R6,D4,L4\n")  == 6
    end

    test "works for example 2" do
      assert Day3.closest_intersection_distance("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83\n")  == 159
    end

    test "works for example 3" do
      assert Day3.closest_intersection_distance("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7\n")  == 135
    end
  end
end
