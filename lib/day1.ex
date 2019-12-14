defmodule Day1 do
  def main do
    {:ok, content} = File.read("files/day1_input.txt")

    content
    |> fuel_count_for()
    |> IO.puts()

    content
    |> total_fuel_for()
    |> IO.puts()
  end

  def fuel_count_for(input) do
    input
    |> fuel_load_for_all_modules(&fuel_load_for_module/1)
  end

  def total_fuel_for(input) do
    input
    |> fuel_load_for_all_modules(&total_fuel_load_for_module/1)
  end

  defp fuel_load_for_all_modules(input, fuel_fn) do
    input
    |> String.split("\n")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&parse_integer/1)
    |> Stream.map(fuel_fn)
    |> Enum.sum()
  end

  defp total_fuel_load_for_module(module_mass) do
    total_fuel_load_for_module(0, module_mass)
  end

  defp total_fuel_load_for_module(accounted_for, 0) do
    accounted_for
  end

  defp total_fuel_load_for_module(accounted_for, additional) do
    fuel = fuel_load_for_module(additional)
    total_fuel_load_for_module(accounted_for + fuel, fuel)
  end

  defp fuel_load_for_module(module_mass) do
    max(
      div(module_mass, 3) - 2,
      0
    )
  end

  defp parse_integer(str) do
    {result, _} = Integer.parse(str)
    result
  end
end
