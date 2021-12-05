defmodule Day4.PartOne do
  def run(filename) do
    # picks_regex = Regex.compile!("/(\d)(?:,?)")
    # is_picks_regex = Regex.compile!("[,]")
    is_picks_regex = ~r/[,]/
    # boards_regex = Regex.compile!(" ?(\d+) +(\d+) +(\d+) +(\d+) +(\d+)")
    boards_regex = ~r/ ?(\d+) +(\d+) +(\d+) +(\d+) +(\d+)/

    read(filename, is_picks_regex, boards_regex)
    |> normalize()
    |> play()
  end

  defp compute_score(board, marked, pick) do
    board
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {_value, value_index} ->
        marked? =
          marked
          |> Enum.at(row_index)
          |> Enum.at(value_index)

        marked? == false
      end)
      |> Enum.map(fn {value, _index} -> value end)
    end)
    |> List.flatten()
    |> Enum.sum()
    |> Kernel.*(pick)
  end

  defp play(data, turn \\ 0, metadata \\ %{winner: nil, winning_pick: nil})
  defp play(%{picks: [], boards: _, marked: _} = data, _turn, _metadata) do
    # IO.puts "Game ended!"
    data
  end
  defp play(%{picks: [pick|rest], boards: boards, marked: marked}, turn, metadata) do
    %{winner: winner, winning_pick: winning_pick} = metadata

    if winner != nil do
      winning_board = Enum.at(boards, winner)
      winning_marked = Enum.at(marked, winner)

      compute_score(winning_board, winning_marked, winning_pick)
    else
      # IO.puts "Playing turn #{turn} with pick #{pick}"
      {boards, updated_marked, metadata} = evaluate(pick, boards, marked, metadata)

      %{picks: rest, boards: boards, marked: updated_marked}
      |> play(turn + 1, metadata)
    end
  end

  defp evaluate(pick, boards, marked_boards, metadata) do
    {updated_marked, metadata} =
      marked_boards
      |> Enum.with_index()
      |> Enum.map_reduce(metadata, fn {marked, board_index}, acc ->
        if acc.winner != nil do
          {marked, acc}
        else
          winning_column? =
            marked_boards
            |> Enum.at(board_index)
            |> Enum.map(&List.first/1)
            |> Enum.all?(& &1 == true)

          if winning_column? do
            {marked, %{acc | winner: board_index}}
          else
            marked
            |> Enum.with_index()
            |> Enum.map_reduce(acc, fn {row, row_index}, acc2 ->
              if acc2.winner != nil do
                {row, acc2}
              else
                winning_row? = Enum.all?(row, & &1 == true)

                if winning_row? do
                  {row, %{acc2 | winner: board_index}}
                else
                  {updated_row, metadata} =
                    row
                    |> Enum.with_index()
                    |> Enum.map_reduce(acc2, fn {found, value_index}, acc3 ->
                      value =
                        Enum.at(boards, board_index)
                        |> Enum.at(row_index)
                        |> Enum.at(value_index)

                      # IO.puts "Already true? #{already_true?}"
                      # IO.puts "Testing #{inspect picks} #{inspect value} #{Enum.member?(picks, value)}"

                      if is_nil(acc3.winner) do
                        if found do
                          {true, acc3}
                        else
                          {pick == value, acc3}
                        end
                      else
                        {false, acc3}
                      end
                    end)

                  winning_row? = Enum.all?(updated_row, & &1 == true)

                  if winning_row? do
                    {updated_row, %{metadata | winner: board_index, winning_pick: pick}}
                  else
                    {updated_row, metadata}
                  end
                end
              end
            end)
          end
        end
      end)

    {boards, updated_marked, metadata}
  end

  defp normalize(data) do
    %{
      data | boards: data.boards |> Enum.reverse(),
      marked: data.marked |> Enum.reverse()
    }
  end

  defp read(filename, is_picks_regex, boards_regex) do
    File.stream!(filename)
    |> Enum.reduce(%{picks: [], boards: [], marked: []}, fn line, acc ->
      cond do
        Regex.match?(is_picks_regex, line) ->
          picks =
            String.split(line, ",")
            |> Enum.map(&cast_to_integer/1)

            %{acc | picks: picks}

        line == "\n" ->
          %{acc | boards: [[]] ++ acc.boards, marked: [[]] ++ acc.marked}

        true ->
          [[_group | matches]] =
            Regex.scan(boards_regex, line)

          matches = matches |> Enum.map(&cast_to_integer/1)

          [board|rest] = acc.boards
          board = board ++ [matches]

          [marked|rest_marked] = acc.marked
          marked = marked ++ [[false, false, false, false, false]]

          %{acc | boards: [board|rest], marked: [marked|rest_marked]}
      end
    end)
  end

  defp cast_to_integer(str) do
    {int, _} = Integer.parse(str)
    int
  end
end
