defmodule Day5.PartOne do
  def run(filename) do
    read(filename)
    # |> build()
    # |> count_intersections()
    |> jose_valim()
  end

  # My implementation takes more than one hour and this takes less than a second.
  # I want to die.
  def jose_valim(lines) do
    lines
    |> Enum.reduce(%{}, fn
      [x, y1, x, y2], grid ->
        Enum.reduce(y1..y2, grid, fn y, grid ->
          Map.update(grid, {x, y}, 1, &(&1 + 1))
        end)

      [x1, y, x2, y], grid ->
        Enum.reduce(x1..x2, grid, fn x, grid ->
          Map.update(grid, {x, y}, 1, &(&1 + 1))
        end)

      _line, grid ->
        grid
    end)
    |> Enum.count(fn {_, v} -> v > 1 end)
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

  defp build(vectors) do
    [size_x, size_y] = find_map_size(vectors)

    coordinates =
      vectors
      |> Enum.map(fn [origin, destination] ->
        unfold(origin, destination)
      end)
      |> List.flatten()

    # IO.puts "size_x: #{inspect size_x}, size_y: #{inspect size_y}"
    # IO.puts "Coordinates:"
    # IO.inspect coordinates

    (0..size_y)
    |> Enum.map(fn y ->
      (0..size_x)
      |> Enum.map(fn x ->
        build_tile(coordinates, x, y)
      end)
    end)
  end

  defp count_intersections(tiles) do
    tiles
    |> List.flatten
    |> Enum.filter(& is_integer(&1) and &1 > 1)
    |> Enum.count()
  end

  defp build_tile(coordinates, x, y) do
    position = {x, y}

    occurrences =
      coordinates
      |> Enum.filter(& &1 == position)
      |> Enum.count()

    case occurrences do
      0 -> "."
      _ -> occurrences
    end
  end

  # Returns a list of coordinates affected by a vector.
  def unfold(origin, destination) do
    # IO.puts "Receiving #{inspect origin} #{inspect destination}"
    range_x = Range.new(List.first(origin), List.first(destination))
    range_y = Range.new(List.last(origin), List.last(destination))

    {list_x, list_y} = to_padded_list(range_x, range_y)

    coordinates = Enum.zip(list_x, list_y)

    if is_diagonal?(coordinates) do
      []
    else
      coordinates
    end
  end

  def to_padded_list(range_x, range_y) do
    size_x = Range.size(range_x)
    size_y = Range.size(range_y)

    list_x = if size_x < size_y do
      diff = size_y - size_x
      list = Enum.into(range_x, [])

      to_append =
        Enum.into(range_x, [])
        |> List.last()
        |> List.duplicate(diff)

      list ++ List.wrap(to_append)
    else
      Enum.into(range_x, [])
    end

    list_y = if size_y < size_x do
      diff = size_x - size_y
      list = Enum.into(range_y, [])

      to_append =
        Enum.into(range_y, [])
        |> List.last()
        |> List.duplicate(diff)

      list ++ List.wrap(to_append)
    else
      Enum.into(range_y, [])
    end

    {list_x, list_y}
  end

  def find_map_size(vectors) do
    pairs =
      vectors
      |> Enum.map(fn [a, b] ->
        [
          [List.first(a), List.first(b)] |> Enum.max(),
          [List.last(a), List.last(b)] |> Enum.max()
        ]
      end)

    [
      Enum.max_by(pairs, &List.first/1) |> List.first(),
      Enum.max_by(pairs, &List.last/1) |> List.last()
    ]
  end



  defp is_diagonal?(coordinates) do
    is_diagonal_a?(coordinates) or is_diagonal_b?(coordinates) or is_diagonal_c?(coordinates)
  end

  defp is_diagonal_a?(coordinates) do
    coordinates
    |> Enum.map(fn {a, b} -> a + b end)
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.==(1)
  end

  defp is_diagonal_b?(coordinates) do
    coordinates
    |> Enum.map(fn {a, b} -> a == b end)
    |> Enum.all?(& &1 == true)
  end

  defp is_diagonal_c?(coordinates) do
    coordinates
    |> Enum.map(fn {a, b} -> a - b end)
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.==(1)
  end
end
