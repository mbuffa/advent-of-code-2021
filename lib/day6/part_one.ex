defmodule Day6.PartOne do
  def run(filename, days) do
    data = read(filename)

    initial_acc = %{parents: 0, day: 0, target: days}

    iterate(data, initial_acc)
    |> Enum.count()
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp iterate(lanternfishes, %{day: day, target: day}) do
    lanternfishes
  end
  defp iterate(lanternfishes, acc) do
    lanternfishes
    |> Enum.map_reduce(%{acc | parents: 0}, fn
      0, acc ->
        {6, Map.update(acc, :parents, 1, & &1 + 1)}
      timer, acc ->
        {timer - 1, acc}
    end)
    |> maybe_spawn_children()
    |> iterate(%{acc | day: acc.day + 1})
  end

  defp maybe_spawn_children({lanternfishes, acc}) do
    parents_count = acc.parents

    if parents_count > 0 do
      lanternfishes ++ List.duplicate(8, parents_count)
    else
      lanternfishes
    end
  end
end
