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

  describe "display" do
    test "renders a single layer as a block of the given width and height" do
      image = Day8.parse_image(encoded: "111111", width: 3, height: 2)

      assert image |> Day8.display() == "111\n111"
    end

    test "renders 0's as spaces" do
      image = Day8.parse_image(encoded: "100110", width: 3, height: 2)

      assert image |> Day8.display() == "1  \n11 "
    end

    test "renders the first layer if it consists of 0's and 1's" do
      image = Day8.parse_image(encoded: "100110000001", width: 3, height: 2)

      assert image |> Day8.display() == "1  \n11 "
    end

    test "treats 2's in the first layer as transparent" do
      image = Day8.parse_image(encoded: "200112000001", width: 3, height: 2)

      assert image |> Day8.display() == "   \n111"
    end

    test "allow multiple layers of transparency" do
      image = Day8.parse_image(encoded: "200112222222000001", width: 3, height: 2)

      assert image |> Day8.display() == "   \n111"
    end
  end
end
