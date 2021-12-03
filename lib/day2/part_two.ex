defmodule Day2.PartTwo do
  defmodule Submarine do
    defstruct [:position, :depth, :aim]
  end

  def run(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> Enum.reduce(%Submarine{position: 0, depth: 0, aim: 0}, fn instruction, submarine ->
      execute_instruction(submarine, instruction)
    end)
    |> compute_multiple()
  end

  defp execute_instruction(submarine, instruction)
  defp execute_instruction(%Submarine{position: position, depth: depth, aim: aim} = submarine, "forward " <> x) do
    n = String.to_integer(x)
    %Submarine{
      submarine |
        position: position + n,
        depth: depth + (n * aim)
    }
  end
  defp execute_instruction(submarine, "up " <> x) do
    n = String.to_integer(x)
    %Submarine{submarine | aim: submarine.aim - n}
  end
  defp execute_instruction(submarine, "down " <> x) do
    n = String.to_integer(x)
    %Submarine{submarine | aim: submarine.aim + n}
  end

  def compute_multiple(%Submarine{position: position, depth: depth}) do
    position * depth
  end
end
