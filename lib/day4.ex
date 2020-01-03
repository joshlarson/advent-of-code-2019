defmodule Day4 do
  def main do
    197487..673251
    |> Enum.count(&valid_password/1)
    |> IO.puts()
  end

  def valid_password(input) do
    has_equal_adjacent_digits(input) && no_decreasing_digits(input)
  end

  def has_equal_adjacent_digits(input) do
    input
    |> digit_pairs()
    |> Enum.any?(fn {a, b} -> a == b end)
  end

  def no_decreasing_digits(input) do
    input
    |> digit_pairs()
    |> Enum.all?(fn {a, b} -> a <= b end)
  end

  defp digit_pairs(input) do
    digits = digits(input)
    Enum.zip(
      Enum.drop(digits, -1),
      Enum.drop(digits, 1)
    )
  end

  def digits(input) do
    digits(input, [])
  end

  defp digits(0, digits_so_far) do
    digits_so_far
  end

  defp digits(number, digits_so_far) do
    digits(div(number, 10), [rem(number, 10) | digits_so_far])
  end
end
