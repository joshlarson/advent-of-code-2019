defmodule Day5 do
  def main do
    {:ok, content} = File.read("files/day5_input.txt")

    code =
      content
      |> String.split(",")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    {:ok, intcode} = %Intcode{code: code, input: [1]} |> Intcode.execute()
    IO.puts(intcode.output |> List.first())

    {:ok, intcode} = %Intcode{code: code, input: [5]} |> Intcode.execute()
    IO.puts(intcode.output |> List.first())
  end
end
