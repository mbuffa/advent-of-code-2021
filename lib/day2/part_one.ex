defmodule Day2.PartOne do
  defmodule Submarine do
    defstruct [:position, :depth]
  end

  def run(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> Enum.reduce(%Submarine{position: 0, depth: 0}, fn instruction, submarine ->
      execute_instruction(submarine, instruction)
    end)
    |> compute_multiple()
  end

  defp execute_instruction(submarine, instruction)
  defp execute_instruction(submarine, "forward " <> x) do
    n = String.to_integer(x)
    %Submarine{submarine | position: submarine.position + n}
  end
  defp execute_instruction(submarine, "up " <> x) do
    n = String.to_integer(x)
    %Submarine{submarine | depth: submarine.depth - n}
  end
  defp execute_instruction(submarine, "down " <> x) do
    n = String.to_integer(x)
    %Submarine{submarine | depth: submarine.depth + n}
  end

  def compute_multiple(%Submarine{position: position, depth: depth}) do
    position * depth
  end
end
