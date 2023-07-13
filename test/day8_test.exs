defmodule Day8Test do
  use ExUnit.Case
  doctest Advent

  describe "an image with a single layer" do
    test "correctly identifies the number of each character in the layer" do
      image = Day8.parse_image(encoded: "123456", width: 3, height: 2)
      layer = image |> Day8.get_layer(0)
      assert layer |> Day8.count_of("3") == 1
      assert layer |> Day8.count_of("9") == 0
    end
  end

  describe "an image with more than one layer" do
    test "correctly identifies the number of each character in the first layer" do
      image = Day8.parse_image(encoded: "123456789012", width: 3, height: 2)

      layer = image |> Day8.get_layer(0)
      assert layer |> Day8.count_of("3") == 1
      assert layer |> Day8.count_of("9") == 0
    end

    test "correctly identifies the number of each character in the second layer" do
      image = Day8.parse_image(encoded: "123456789012", width: 3, height: 2)

      layer = image |> Day8.get_layer(1)
      assert layer |> Day8.count_of("3") == 0
      assert layer |> Day8.count_of("9") == 1
    end
  end

  describe "an image with smaller layers" do
    test "correctly identifies the number of each character in the first layer" do
      image = Day8.parse_image(encoded: "123456789012", width: 2, height: 2)

      layer = image |> Day8.get_layer(0)
      assert layer |> Day8.count_of("3") == 1
      assert layer |> Day8.count_of("7") == 0
      assert layer |> Day8.count_of("9") == 0
    end

    test "correctly identifies the number of each character in the second layer" do
      image = Day8.parse_image(encoded: "123456789012", width: 2, height: 2)

      layer = image |> Day8.get_layer(1)
      assert layer |> Day8.count_of("3") == 0
      assert layer |> Day8.count_of("7") == 1
      assert layer |> Day8.count_of("9") == 0
    end

    test "correctly identifies the number of each character in the third layer" do
      image = Day8.parse_image(encoded: "123456789012", width: 2, height: 2)

      layer = image |> Day8.get_layer(2)
      assert layer |> Day8.count_of("3") == 0
      assert layer |> Day8.count_of("7") == 0
      assert layer |> Day8.count_of("9") == 1
    end
  end

  describe "min_layer_by_count" do
    test "works" do
      image = Day8.parse_image(encoded: "123456789012", width: 2, height: 2)

      layer = image |> Day8.min_layer_by_count("1")
      assert layer |> Day8.count_of("7") == 1
    end
  end
end
