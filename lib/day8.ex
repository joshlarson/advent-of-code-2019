defmodule Day8 do
  def main() do
    {:ok, content} = File.read("files/day8_input.txt")

    image =
      parse_image(
        encoded: content |> String.replace_trailing("\n", ""),
        width: 25,
        height: 6
      )

    part1_layer = image |> min_layer_by_count("0")
    IO.puts(count_of(part1_layer, "1") * count_of(part1_layer, "2"))
  end

  def parse_image(encoded: encoded, width: width, height: height) do
    %{layers: encoded |> String.codepoints() |> Enum.chunk_every(width * height)}
  end

  def get_layer(%{layers: layers}, layer_index) do
    layers |> Enum.at(layer_index)
  end

  def count_of(layer, char) do
    layer |> Enum.count(fn c -> c == char end)
  end

  def min_layer_by_count(%{layers: layers}, char) do
    layers |> Enum.min_by(fn l -> l |> count_of(char) end)
  end
end
