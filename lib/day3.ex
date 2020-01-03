defmodule Day3 do
  defmodule Point do
    def origin() do
      %{x: 0, y: 0}
    end

    def right(%{x: x, y: y}) do
      %{x: x + 1, y: y}
    end

    def up(%{x: x, y: y}) do
      %{x: x, y: y + 1}
    end

    def left(%{x: x, y: y}) do
      %{x: x - 1, y: y}
    end

    def down(%{x: x, y: y}) do
      %{x: x, y: y - 1}
    end

    def manhattan_distance(%{x: x, y: y}) do
      abs(x) + abs(y)
    end
  end

  defmodule Wire do
    def new() do
      %{
        end: Point.origin(),
        points: %{}
      }
    end

    def advance_end(%{end: pt, points: points}, fun) do
      %{x: x, y: y} = new_pt = fun.(pt)

      %{
        end: new_pt,
        points: points |> Map.put({x, y}, new_pt)
      }
    end

    def includes?(%{points: points}, cell) do
      Map.has_key?(points, cell)
    end

    def points(%{points: points}) do
      points |> Map.values()
    end

    def intersection_with(%{points: points}, point = %{x: x, y: y}) do
      cell = {x, y}
      case points do
        %{^cell => other_point} -> [{point, other_point}]
        %{} -> []
      end
    end
  end

  defmodule IntersectionSet do
    def new(point_list) do
      point_list
    end

    def manhattan_distance({pt1, _pt2}) do
      Point.manhattan_distance(pt1)
    end
  end

  def main do
    {:ok, content} = File.read("files/day3_input.txt")

    closest_intersection_distance(content)
    |> IO.puts()
  end

  def closest_intersection_distance(input) do
    find_intersections(input)
    |> Stream.map(&IntersectionSet.manhattan_distance/1)
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
    |> Wire.points()
    |> Stream.flat_map(fn point -> wire2 |> Wire.intersection_with(point) end)
    |> IntersectionSet.new()
  end

  def includes_intersection?(intersections, {x, y}) do
    intersections
    |> Enum.any?(fn
      {%{x: ^x, y: ^y}, _} -> true
      {_, _} -> false
    end)
  end

  def build_path(input) do
    input
    |> String.split(",")
    |> Stream.flat_map(&parse_path_instruction/1)
    |> Enum.reduce(Wire.new(), fn fun, wire -> Wire.advance_end(wire, fun) end)
  end

  def wire_includes?(wire, cell) do
    Wire.includes?(wire, cell)
  end

  defp parse_path_instruction(str) do
    <<dir :: binary-1, length_str :: binary>> = str

    {length, ""} = Integer.parse(length_str)

    fun = %{
      "R" => &Point.right/1,
      "U" => &Point.up/1,
      "L" => &Point.left/1,
      "D" => &Point.down/1
    } |> Map.fetch!(dir)

    List.duplicate(fun, length)
  end
end
