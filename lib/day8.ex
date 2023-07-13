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

    IO.puts(display(image))
  end

  def parse_image(encoded: encoded, width: width, height: height) do
    %{
      layers: encoded |> String.codepoints() |> Enum.chunk_every(width * height),
      width: width
    }
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

  def display(%{layers: layers, width: width}) do
    combined_layer = layers |> combine()

    combined_layer
    |> Enum.chunk_every(width)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> String.replace("0", " ")
  end

  defp combine([only_layer]) do
    only_layer
  end

  defp combine([first_layer | rest_of_layers]) do
    Enum.zip(first_layer, combine(rest_of_layers))
    |> Enum.map(fn
      {"2", char1} -> char1
      {char0, _char1} -> char0
    end)
  end
end
