defmodule Advent do
  def main(args) do
    mods = %{
      "day1" => Day1,
      "day2" => Day2,
      "day3" => Day3,
      "day4" => Day4,
      "day5" => Day5
    }

    {day_n, mod} =
      if Enum.any?(args) do
        key = List.first(args)
        {key, mods[key]}
      else
        last_tuple_of(mods)
      end

    IO.puts("Running #{day_n}")
    mod.main
  end

  defp last_tuple_of(map) do
    map |> Enum.to_list() |> List.last()
  end
end
