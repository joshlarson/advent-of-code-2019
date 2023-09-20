defmodule Day9 do
  def main do
    {:ok, content} = File.read("files/day9_input.txt")

    code =
      content
      |> String.split(",")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    {:ok, intcode} = Intcode.new(code: code) |> Intcode.add_input([1]) |> Intcode.execute()
    IO.puts(intcode.output |> List.first())
  end
end
