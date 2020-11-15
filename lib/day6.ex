defmodule Day6 do
  def main() do
    {:ok, content} = File.read("files/day6_input.txt")

    orbit_map =
      content
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> orbit_map()

    orbit_map
    |> full_orbit_count()
    |> IO.puts()

    orbit_map
    |> transfers_to_santa()
    |> IO.inspect()
  end

  def orbit_map(args) do
    args
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.map(fn [orbitee, orbiter] -> {orbiter, orbitee} end)
    |> Map.new()
  end

  defp orbit_list(map, orbiter) do
    case map do
      %{^orbiter => orbitee} -> [orbitee | orbit_list(map, orbitee)]
      %{} -> []
    end
  end

  def orbit_count(map, orbiter) do
    orbit_list(map, orbiter) |> Enum.count()
  end

  def full_orbit_count(map) do
    map
    |> Enum.map(fn {orbiter, _} -> map |> orbit_count(orbiter) end)
    |> Enum.sum()
  end

  def transfers_to_santa(map) do
    {you_path, santa_path} =
      drop_common_entries(
        map |> orbit_list("YOU") |> Enum.reverse(),
        map |> orbit_list("SAN") |> Enum.reverse()
      )

    (you_path |> Enum.count()) + (santa_path |> Enum.count())
  end

  defp drop_common_entries(list1, list2) do
    case {list1, list2} do
      {[first | rest1], [first | rest2]} -> drop_common_entries(rest1, rest2)
      {_, _} -> {list1, list2}
    end
  end
end
