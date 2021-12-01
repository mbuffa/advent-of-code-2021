defmodule Day1 do
  def run(filename) do
    content =
      File.read!(filename)
      |> String.split("\n")

    initial =
      content
      |> List.first()

    {_value, occurrences} =
      content
      |> Enum.reduce({initial, 0}, fn (x, {prev, occurrences}) ->
        if x > prev do
          # IO.puts "#{x} (increased)"
          {x, occurrences + 1}
        else
          # IO.puts "#{x} (decreased)"
          {x, occurrences}
        end
      end)

    IO.puts "Depth increased #{occurrences} times."
  end

  def run_part_two(filename) do
    content =
      File.read!(filename)
      |> String.split("\n")

    initial =
      content
      |> List.first()

    {_value, increases} = part_two(content, {initial, 0})

    IO.puts "Depth increased #{increases} times."
  end

  defp part_two(list, {prev, increases}) do
    if list == [] do
      {prev, increases}
    else
      window =
        list
        |> Enum.take(3)
        |> Enum.map(& String.to_integer(&1))
        |> Enum.sum()

      increases =
        if window > prev do
          increases + 1
        else
          increases
        end

      [_|new_list] = list

      part_two(new_list, {window, increases})
    end
  end
end
