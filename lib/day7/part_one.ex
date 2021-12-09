defmodule Day7.PartOne do
  def run(filename) do
    data = read(filename)

    computed = compute(data)

    cheapest =
      Enum.map(computed, fn {_, v_row} ->
        Enum.map(v_row, & elem(&1, 1)) |> Enum.sum()
      end)
      |> Enum.min()

    cheapest
  end

  def compute(data) do
    0..length(data) - 1
    |> Enum.reduce(%{}, fn move_to, acc ->
      costs =
        data
        |> Enum.map(fn value ->
          {value, abs(move_to - value)}
        end)

      Map.put(acc, move_to, costs)
    end)
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
