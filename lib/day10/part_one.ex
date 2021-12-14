defmodule Day10.PartOne do
  @maluses %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25137
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

    Enum.reduce(data, 0, fn line, score ->
      case parse(line) do
        {:corrupted, char} ->
          score + Map.fetch!(@maluses, char)

        _ -> score
      end
    end)
  end

  def read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end
end
