defmodule Day8.PartOne do
  # Segments to number association
  @compositions %{
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8
  }

  def run(filename) do
    read(filename)
    |> Enum.reduce(%{}, fn {_signals, digits}, acc ->
      Enum.reduce(digits, acc, fn digit, acc ->
        segments_count = String.length(digit)
        digit_found = Map.get(@compositions, segments_count)

        if is_integer(digit_found), do: Map.update(acc, digit_found, 1, & &1 + 1), else: acc
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [signals | [digits]] = String.split(line, " | ")

      Enum.map([signals, digits], & String.split(&1, " ")) |> List.to_tuple()
    end)
  end
end
