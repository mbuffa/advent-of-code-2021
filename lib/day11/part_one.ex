defmodule Day11.PartOne do
  def run(filename) do
    read(filename) |> iterate()
  end

  def increase_energy(octopuses) when is_map(octopuses) do
    Enum.map(octopuses, fn {k, v} -> increase_energy({k, v}) end)
  end
  def increase_energy({k, 9}), do: {k, 0}
  def increase_energy({k, v}), do: {k, v + 1}

  def propagate_energy(tiles, _, []), do: tiles
  def propagate_energy(tiles, {new_flash_x, new_flash_y}, [{{x, y}, _v} = _head|tail]) do
    neighbors =
      get_neighbors(tiles, {new_flash_x, new_flash_y})
      |> Enum.reject(fn {_k, v} -> v == 0 end)

    tiles =
      Enum.map(tiles, fn {{tx, ty}, _} = tile ->
        if tx == x and ty == y, do: increase_energy(tile), else: tile
      end)

    open_list = Enum.uniq(tail ++ neighbors)

    propagate_energy(tiles, {x, y}, open_list)
  end

  # Start clause
  def iterate(tiles) do
    iterate(tiles, 0, 0)
  end

  def iterate(tiles, step, flashes)
  # End clause
  def iterate(tiles, 2, flashes) do
    {tiles, flashes}
  end
  def iterate(tiles, step, flashes) do
    tiles = increase_energy(tiles)

    new_flashes = tiles |> Enum.filter(fn {_k, v} -> v == 0 end)

    tiles =
      new_flashes
      |> Enum.reduce(new_flashes, fn {{x, y}, _v}, acc ->
        propagate_energy(tiles, {x, y}, acc)
      end)

    iterate(tiles, step + 1, flashes)
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

    data = data |> Map.new()
    # IO.inspect data

    for x <- rangex, y <- rangey do
      {{x, y}, Map.get(data, {x, y})}
    end
    |> Enum.reject(fn {{x, y}, v} -> x == ox and y == oy or is_nil(v) end)
  end
end
