defmodule Day10.PartTwo do
  @maluses %{
    ?) => 1,
    ?] => 2,
    ?} => 3,
    ?> => 4
  }

  def parse(chars), do: parse(chars, [])

  def parse(chars, stack)

  # Openers
  def parse(<<?(, tail::binary>>, stack), do: parse(tail, [?) | stack])
  def parse(<<?[, tail::binary>>, stack), do: parse(tail, [?] | stack])
  def parse(<<?{, tail::binary>>, stack), do: parse(tail, [?} | stack])
  def parse(<<?<, tail::binary>>, stack), do: parse(tail, [?> | stack])

  # Terminator
  def parse(<<char, tail::binary>>, [char | stack]), do: parse(tail, stack)
  def parse(<<char, _tail::binary>>, _stack), do: {:corrupted, char}

  def parse(<<>>, []), do: :ok
  def parse(<<>>, stack), do: {:incomplete, stack}

  def run(filename) do
    data = read(filename)

    scores =
      Enum.map(data, &parse/1)
      |> Enum.filter(fn
        {:incomplete, _stack} -> true
        _ -> false
      end)
      |> Enum.map(fn {:incomplete, sequence} ->
        Enum.reduce(sequence, 0, fn char, score ->
          score * 5 + Map.fetch!(@maluses, char)
        end)
      end)
      |> Enum.sort()

    Enum.fetch!(scores, div(length(scores), 2))
  end

  def read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end
end
