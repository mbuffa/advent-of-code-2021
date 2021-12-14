defmodule Day10.PartOne do
  defmodule Node do
    defstruct id: nil, opener: nil, terminator: nil, children: [], valid: false
  end

  @openers ["(", "[", "<", "{"]
  @terminators [")", "]", ">", "}"]
  @matching_pairs Enum.zip(@openers, @terminators)

  @maluses %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  def is_valid?(%Node{opener: opener, terminator: terminator}) do
    Enum.member?(@matching_pairs, {opener, terminator})
  end

  def is_opener?(character), do: Enum.member?(@openers, character)
  def is_terminator?(character), do: Enum.member?(@terminators, character)

  def child_count(node)
  def child_count(%Node{children: []}), do: 0
  def child_count(%Node{children: children}) do
    # 1 + child_count(head)
    Enum.reduce(children, 1, fn child, acc ->
      acc + child_count(child)
    end)
  end

  def count_children(%Node{children: children}, count) do
    Enum.reduce(children, count, fn child, acc ->
      acc + child_count(child)
    end)
  end

  # def parse(node \\ %Node{id: 0}, characters \\ ["(", "(", ")", ")"], level \\ 0)
  def parse(node \\ %Node{id: 0}, characters, level \\ 0)
  def parse(tree, [], _), do: tree
  def parse(node, [char|tail], level) do
    if is_opener?(char) do
      IO.inspect {char, :is_opener, level}

      if node.id == level do
        if is_nil(node.opener) do
          parse(%Node{node | opener: char}, tail, level)
        else
          # existing_max_level =
          #   Enum.max_by(node.children, &(Map.get(&1, :id)), fn -> %{id: level} end)
          #   |> Map.get(:id)

          # child = parse(%Node{id: existing_max_level + 1, opener: char}, tail, existing_max_level + 1)

          # rest =
            if tail != [] do
              existing_max_level =
                Enum.max_by(node.children, &(Map.get(&1, :id)), fn -> %{id: level} end)
                |> Map.get(:id)

              child = parse(%Node{id: existing_max_level + 1, opener: char}, tail, existing_max_level + 1)
              children_count = count_children(%{node| children: node.children ++ [child]}, 0)

              # [_|rest] = tail
              # rest = for _ <- 0..((children_count * 2)) do
              #   [_|rest] = rest
              #   rest
              # end
              # [_|rest] = tail
              # [_|rest] = rest
              # rest

              rest = compute_rest(level, children_count, tail)

              IO.inspect {:err, level, node.opener, rest, tail}
              %Node{node | children: node.children ++ [child]}
              |> parse(rest, level)
            else
              %Node{node | terminator: char}
            end

          # %Node{node | children: node.children ++ [child]}
          # |> parse(rest, level)
        end
      else
        IO.puts "STUB1"
        node
      end
    else
      IO.inspect {char, :is_terminator, level}

      # Parents always get the first terminator they can get.

      if node.id == level do
        if is_nil(node.terminator) do
          node = %Node{node | terminator: char}
          %Node{node | valid: is_valid?(node)}
        else
          IO.puts "STUB3"
          node
        end
      else
        IO.puts "STUB2"
        node
      end
    end
  end


  def run(filename) do
    read(filename)
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, line_index}, acc ->
      chars = String.codepoints(line)
      tree = parse(%Node{id: 0}, chars, 0)
      IO.inspect tree
      # IO.inspect line_index
      error_score = calculate_score(tree)
      # if error_score == 0 do
      #   IO.inspect {line_index, tree}
      # end
      acc ++ [{line_index, error_score}]
      # acc
    end)
    # |> Enum.map(&(elem(&1, 1)))
    # |> Enum.sum()
  end

  def read(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
  end

  # Since I'm running through the nodes recursively from the root,
  # without either touching the nodes, I need that function to remove
  # nodes that have been picked by children, starting from 0 since I
  # need to start from the next character after encountering the first
  # child opening one.
  def compute_rest(level, children_count, tail) do
    # IO.inspect {level, children_count, tail}

    rest =
      Enum.reduce(0..(children_count*2), tail, fn
         _, [_|tail] ->
          tail
         _, [] -> []
      end)

    rest
  end

  def calculate_score(%Node{} = tree) do
    explore_tree([tree])
  end



  def explore_tree([]), do: 0
  def explore_tree([%Node{valid: false, terminator: terminator} = node|_tail]) do
    # IO.inspect node
    Map.fetch!(@maluses, terminator)
  end
  def explore_tree([%Node{valid: true}|tail]) do
    explore_tree(tail)
  end
  def explore_tree([%Node{valid: true, children: children}]) do
    explore_tree(children |> Enum.reverse())
  end
end
