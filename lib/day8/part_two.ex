defmodule Day8.PartTwo do
  def run(filename) do
    read(filename)
    |> Enum.reduce([], fn {signals, digits}, acc ->
      numbers_to_signals = identify(signals)

      number =
        Enum.map(digits, fn str ->
          Enum.find(numbers_to_signals, fn {_, v} ->
            distance(str, v) == 0
          end)
          |> elem(0)
        end)
        |> Enum.join()
        |> String.to_integer()

      acc ++ [number]
    end)
    |> Enum.sum()
  end

  def identify(signals) do
    compositions = find_easy_numbers(signals)
    compositions = find_patterns(signals, compositions, 4, [{6, 9}])
    compositions = find_patterns(signals, compositions, 1, [{5, 3}, {6, 0}])

    knowns = Map.values(compositions)

    # Deduce 6
    compositions = Enum.reduce(signals, compositions, fn signal, acc ->
      away_from_8 = compositions[8] |> distance(signal)

      if away_from_8 == 1 and not Enum.member?(knowns, signal) do
        Map.put(acc, 6, signal)
      else
        acc
      end
    end)

    # Deduce 5
    compositions = Enum.reduce(signals, compositions, fn signal, acc ->
      away_from_6 = compositions[6] |> distance(signal)

      if away_from_6 == 1 and not Enum.member?(knowns, signal) do
        Map.put(acc, 5, signal)
      else
        acc
      end
    end)

    # Deduce 2
    Enum.reduce(signals, compositions, fn signal, acc ->
      knowns = Map.values(compositions)

      if not Enum.member?(knowns, signal) do
        Map.put(acc, 2, signal)
      else
        acc
      end
    end)
  end

  def find_easy_numbers(signals) when is_list(signals) do
    Enum.reduce(signals, %{}, fn signal, acc ->
      case String.length(signal) do
        2 -> Map.put(acc, 1, signal)
        3 -> Map.put(acc, 7, signal)
        4 -> Map.put(acc, 4, signal)
        7 -> Map.put(acc, 8, signal)
        _ -> acc
      end
    end)
  end

  def find_patterns(signals, compositions, to_find, if_matches) do
    unknowns =
      Enum.filter(signals, fn signal ->
        contains?(signal, compositions[to_find])
      end)
      |> Enum.reject(fn signal ->
        Enum.member?(Map.values(compositions), signal)
      end)

    if Enum.count(unknowns) == 1 do
      Map.put(compositions, if_matches |> List.first() |> elem(1), unknowns |> List.first())
    else
      maybe_deduce_multiple(compositions, unknowns, if_matches)
    end
  end

  def maybe_deduce_multiple(compositions, unknowns, if_matches) do
    all_same_size? =
      Enum.map(unknowns, &String.length/1)
      |> Enum.uniq()
      |> List.first()
      |> Kernel.==(1)

    if all_same_size? do
      raise "Caught more than one unknown signal."
    else
      find_tricky_numbers(unknowns, compositions, if_matches)
    end
  end

  def find_tricky_numbers(signals, compositions, if_matches) do
    Enum.map(if_matches, fn {length, position} ->
      found =
        Enum.find(signals, fn signal ->
          String.length(signal) == length
        end)

      {found, position}
    end)
    |> Enum.reduce(compositions, fn {signal, position}, acc ->
      Map.put(acc, position, signal)
    end)
  end

  def read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [signals | [digits]] = String.split(line, " | ")

      Enum.map([signals, digits], & String.split(&1, " ")) |> List.to_tuple()
    end)
  end

  def to_list(string), do: String.codepoints(string)

  def contains?(source, pattern) do
    source = to_list(source)

    Enum.all?(to_list(pattern), fn char ->
      Enum.member?(source, char)
    end)
  end

  def distance(source, pattern) do
    source = to_list(source)
    pattern = to_list(pattern)

    if Enum.count(source) > Enum.count(pattern) do
      (source -- pattern) |> Enum.count()
    else
      (pattern -- source) |> Enum.count()
    end
  end
end
