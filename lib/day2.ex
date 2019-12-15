defmodule Day2 do
  def main do
    {:ok, content} = File.read("files/day2_input.txt")

    content
    |> parse()
    |> execute1202()
    |> List.first()
    |> IO.puts()
  end

  def execute1202(code) do
    code
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> Intcode.execute()
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end
end
