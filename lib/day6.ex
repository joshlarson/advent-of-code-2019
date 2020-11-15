defmodule Day6 do
  def main() do
    {:ok, content} = File.read("files/day6_input.txt")

    content
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> orbit_map()
    |> full_orbit_count()
    |> IO.puts()
  end

  def orbit_map(args) do
    args
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.map(fn [orbitee, orbiter] -> {orbiter, orbitee} end)
    |> Map.new()
  end

  def orbit_count(map, orbiter) do
    case map do
      %{^orbiter => orbitee} -> 1 + orbit_count(map, orbitee)
      %{} -> 0
    end
  end

  def full_orbit_count(map) do
    map
    |> Enum.map(fn {orbiter, _} -> map |> orbit_count(orbiter) end)
    |> Enum.sum()
  end
end
