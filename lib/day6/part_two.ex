defmodule Day6.PartTwo do
  def run(filename, days) do
    data = read(filename)
    |> Enum.frequencies()

    initial_acc = %{parents: 0, day: 0, target: days}

    iterate(data, initial_acc)
    |> Map.values()
    |> Enum.sum()
  end

  defp read(filename) do
    File.read!(filename)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp iterate(frequencies, %{day: day, target: day}) do
    frequencies
  end
  defp iterate(frequencies, %{day: day, target: target}) do
    initial_acc = %{parents: 0, new: %{}, day: day, target: target}

    frequencies
    |> Enum.map_reduce(initial_acc, fn
      {0, v}, acc ->
        {
          {0, Map.get(acc.new, 0, 0)},
          acc
          |> Map.replace(:parents, v)
          |> Map.update(:new, %{}, & Map.update(&1, 6, v, fn x -> x + v end))
        }

      {k, v}, acc ->
        {
          {k, Map.get(acc.new, k + 1, 0)},
          Map.update(acc, :new, %{}, & Map.update(&1, k - 1, v, fn x -> x + v end))
        }
    end)
    |> remove_zeroes()
    |> apply_new()
    |> maybe_spawn_children()
    |> iterate(%{initial_acc | day: initial_acc.day + 1})
  end

  defp remove_zeroes({frequencies, acc}) do
    {
      Enum.reject(frequencies, fn {_k, v} ->
        v == 0
      end),
     acc
    }
  end

  defp apply_new({_frequencies, %{new: new} = acc}) do
    {new, acc}
  end

  defp maybe_spawn_children({%{} = frequencies, %{parents: 0}}) do
    frequencies
  end
  defp maybe_spawn_children({frequencies, %{parents: parents}}) do
    Map.update(frequencies, 8, parents, & &1 + parents)
  end
end
