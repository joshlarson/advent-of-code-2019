defmodule Advent do
  def main(args) do
    mods = %{
      "day1" => Day1,
      "day2" => Day2,
      "day3" => Day3,
      "day4" => Day4,
      "day5" => Day5,
      "day6" => Day6,
      "day7" => Day7
    }

    day_n =
      if Enum.any?(args) do
        List.first(args)
      else
        "day7"
      end

    mod = mods[day_n]

    IO.puts("Running #{day_n}")
    mod.main
  end
end
