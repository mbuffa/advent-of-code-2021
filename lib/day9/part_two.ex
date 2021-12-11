defmodule Day9.PartTwo do
  def run(filename) do
    data = read(filename)
    local_lows = find_local_lows(data)

    explore_local_lows(data, local_lows)
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

  def explore_local_lows(data, local_lows) do
    Enum.map(local_lows, fn {position, _} = origin ->
      neighbors = get_neighbors(data, position)
      explore_basin(data, position, [origin], neighbors) |> Enum.count()
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
  end

  def explore_basin(map, origin, closed_list, open_list)
  def explore_basin(_, _, closed_list, []) do
    closed_list
  end
  def explore_basin(map, origin, closed_list, [{{x, y}, _} = head|tail] = open_list) do
    neighbors =
      get_neighbors(map, {x, y})
      |> Enum.reject(fn {{nx, ny}, _nv} = neighbor ->
        Enum.member?(closed_list, neighbor) or Enum.member?(open_list, neighbor) or {nx, ny} == origin
      end)

    nodes = Enum.uniq(tail ++ neighbors)

    explore_basin(map, origin, [head|closed_list], nodes)
  end

  def get_neighbors(data, {ox, oy}) do
    rangex = (ox - 1)..(ox + 1) |> Enum.into([])
    rangey = (oy - 1)..(oy + 1) |> Enum.into([])

    for x <- rangex, y <- rangey do
      {{x, y}, Map.get(data, {x, y})}
    end
    |> Enum.reject(fn {{x, y}, v} ->
      (x == ox and y == oy) or (x != ox and y != oy) or is_nil(v) or v == 9
    end)
  end

  def find_local_lows(data) do
    Enum.reduce(data, [], fn {{x, y}, v}, acc ->
      neighbors = get_neighbors(data, {x, y})
      local_low? = Enum.all?(neighbors, fn {_, neighbor} -> v < neighbor end)

      if local_low?, do: [{{x, y}, v}|acc], else: acc
    end)
    |> Enum.reverse()
  end
end
