defmodule Day10 do
  def main() do
    {:ok, content} = File.read("files/day10_input.txt")

    asteroid_map = asteroid_map(content |> String.split("\n"))

    asteroid_map
    |> best_detection_count()
    |> IO.puts()
  end

  def asteroid_map(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> parse_line()
      |> Enum.map(&Map.put(&1, :y, y))
    end)
    |> MapSet.new()
  end

  defp parse_line(line) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.filter(fn
      {"#", _} -> true
      _ -> false
    end)
    |> Enum.map(fn
      {_, x} -> %{x: x}
    end)
  end

  def list_asteroids(map) do
    map
  end

  def detected_from(map, x, y) do
    map
    |> Enum.map(fn %{x: other_x, y: other_y} -> %{dx: other_x - x, dy: other_y - y} end)
    |> Enum.filter(fn %{dx: dx, dy: dy} -> !(dx == 0 && dy == 0) end)
    |> Enum.map(fn %{dx: dx, dy: dy} ->
      gcd = gcd(dx, dy)
      %{dx: div(dx, gcd), dy: div(dy, gcd)}
    end)
    |> MapSet.new()
    |> Enum.count()
  end

  def best_detection_count(map) do
    map
    |> Enum.map(fn %{x: x, y: y} ->
      map |> detected_from(x, y)
    end)
    |> Enum.max()
  end

  def gcd(a, b) when a < 0, do: gcd(-a, b)
  def gcd(a, b) when b < 0, do: gcd(a, -b)
  def gcd(a, b) when b > a, do: gcd(b, a)
  def gcd(a, b) when b == 0, do: a
  def gcd(a, b) when rem(a, b) == 0, do: b
  def gcd(a, b), do: gcd(a - b, b)
end
