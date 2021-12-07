defmodule Day6.PartOne do
  def run(filename, days) do
    data = read(filename)

    Enum.reduce(1..days, data, fn _day, acc ->
      iterate(acc)
    end)
    |> Enum.count()
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp iterate(lanternfishes) do
    lanternfishes
    |> Enum.map(fn
      0 -> 6
      timer -> timer - 1
    end)
    |> maybe_spawn_children(lanternfishes)
  end

  defp maybe_spawn_children(lanternfishes, previous) do
    parents_count =
      Enum.count(lanternfishes, & &1 == 6) - Enum.count(previous, & &1 == 7)

    if parents_count > 0 do
      lanternfishes ++ List.duplicate(8, parents_count)
    else
      lanternfishes
    end
  end
end
