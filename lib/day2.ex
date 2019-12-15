defmodule Day2 do
  def main do
    {:ok, content} = File.read("files/day2_input.txt")

    code =
      content
      |> parse()

    code
    |> execute1202()
    |> elem(1)
    |> List.first()
    |> IO.puts()

    {noun, verb} =
      code
      |> find_noun_and_verb(19_690_720)

    IO.puts(noun * 100 + verb)
  end

  def execute1202(code) do
    execute_with_noun_and_verb(code, 12, 2)
  end

  def find_noun_and_verb(code, output) do
    square_grid(99)
    |> Enum.find(fn
      {noun, verb} ->
        case execute_with_noun_and_verb(code, noun, verb) do
          {:ok, thing} -> thing |> List.first() == output
          {:error} -> false
        end
    end)
  end

  defp square_grid(size) do
    0..size
    |> Stream.flat_map(fn x -> 0..size |> Stream.map(fn y -> {x, y} end) end)
  end

  def execute_with_noun_and_verb(code, noun, verb) do
    code
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> Intcode.execute()
  end

  def parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end
end
