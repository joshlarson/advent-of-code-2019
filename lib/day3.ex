defmodule Day3 do
  def main do
    {:ok, content} = File.read("files/day3_input.txt")

    closest_intersection_distance(content)
    |> IO.puts()
  end

  def closest_intersection_distance(input) do
    find_intersections(input)
    |> Stream.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min
  end

  def find_intersections(input) do
    [wire1, wire2] =
      input
      |> String.split("\n")
      |> Stream.filter(&(&1 != ""))
      |> Stream.map(&build_path/1)
      |> Enum.take(2)

    wire1
    |> Stream.filter(&(wire_includes?(wire2, &1)))
    |> Stream.filter(&(&1 != {0, 0}))
    |> MapSet.new()
  end

  def build_path(input) do
    input
    |> String.split(",")
    |> Stream.flat_map(&parse_path_instruction/1)
    |> Enum.reduce([{0, 0}], fn fun, memo = [pt| _] -> [fun.(pt) | memo] end)
    |> MapSet.new()
  end

  defp parse_path_instruction(str) do
    <<dir :: binary-1, length_str :: binary>> = str

    {length, ""} = Integer.parse(length_str)

    fun = %{
      "R" => fn {x, y} -> {x + 1, y} end,
      "U" => fn {x, y} -> {x, y + 1} end,
      "L" => fn {x, y} -> {x - 1, y} end,
      "D" => fn {x, y} -> {x, y - 1} end,
    } |> Map.fetch!(dir)

    List.duplicate(fun, length)
  end

  def includes_intersection?(intersections, point) do
    intersections |> MapSet.member?(point)
  end

  def wire_includes?(wire, point) do
    MapSet.member?(wire, point)
  end
end
