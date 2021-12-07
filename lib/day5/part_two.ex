defmodule Day5.PartTwo do
  def run(filename) do
    read(filename)
    |> count_occurrences()
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", " -> "])
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp count_occurrences(lines) do
    lines
    |> Enum.reduce(%{}, fn
      [x, y1, x, y2], grid ->
        Enum.reduce(y1..y2, grid, fn y, grid ->
          Map.update(grid, {x, y}, 1, & &1 + 1)
        end)

      [x1, y, x2, y], grid ->
        Enum.reduce(x1..x2, grid, fn x, grid ->
          Map.update(grid, {x, y}, 1, & &1 + 1)
        end)

      [x1, y1, x2, y2], grid ->
        Enum.zip(x1..x2, y1..y2)
        |> Enum.reduce(grid, fn point, grid ->
          Map.update(grid, point, 1, & &1 + 1)
        end)
    end)
    |> Map.values()
    |> Enum.count(& &1 > 1)
  end
end
