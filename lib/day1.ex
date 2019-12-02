defmodule Day1 do
  def main do
    {:ok, content} = File.read("files/day1_input.txt")

    content
    |> fuel_count_for()
    |> IO.puts()
  end

  def fuel_count_for(input) do
    input
    |> String.split("\n")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&parse_integer/1)
    |> Stream.map(&fuel_load_for_module/1)
    |> Enum.sum()
  end

  defp fuel_load_for_module(module_mass) do
    div(module_mass, 3) - 2
  end

  defp parse_integer(str) do
    {result, _} = Integer.parse(str)
    result
  end
end
