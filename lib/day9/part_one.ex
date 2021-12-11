defmodule Day9.PartOne do
  def run(filename) do
    data = read(filename)

    Enum.reduce(data, [], fn {{x, y}, v}, acc ->
      neighbors = get_neighbors(data, {x, y})
      local_low? = Enum.all?(neighbors, fn {_, neighbor} -> v < neighbor end)

      if local_low?, do: [1 + v|acc], else: acc
    end)
    |> Enum.sum()
  end

  def read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {point, x}, map ->
        Map.put(map, {x, y}, point |> String.to_integer())
      end)
    end)
  end

  def get_neighbors(data, {ox, oy}) do
    rangex = (ox - 1)..(ox + 1) |> Enum.into([])
    rangey = (oy - 1)..(oy + 1) |> Enum.into([])

    for x <- rangex, y <- rangey do
      {{x, y}, Map.get(data, {x, y})}
    end
    |> Enum.reject(fn {{x, y}, v} -> x == ox and y == oy or is_nil(v) end)
  end
end
