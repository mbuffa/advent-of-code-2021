defmodule Day3.PartOne do
  defmodule Data do
    defstruct [:raw]
  end

  def run(filename) do
    data =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.reduce(%Data{raw: []}, fn line, acc ->
        bits =
          String.split(line, "")
          |> Enum.slice(1, String.length(line))

        %{acc | raw: acc.raw ++ [bits]}
      end)

    bitsize =
      data.raw
      |> List.first()
      |> Enum.count()

    sample_size = Enum.count(data.raw)

    {gamma, epsilon} =
      (0..bitsize - 1)
      |> Enum.reduce({[], []}, fn column, acc ->
        column_bits =
          Enum.reduce(data.raw, [], fn bits, acc ->
            acc ++ [Enum.at(bits, column)]
          end)

        only_ones =
          column_bits
          |> Enum.reject(& &1 == "0")

        majority_of_ones =
          Enum.count(only_ones) > (sample_size / 2)

        gamma = if majority_of_ones, do: 1, else: 0
        epsilon = if majority_of_ones, do: 0, else: 1

        {elem(acc, 0) ++ [gamma], elem(acc, 1) ++ [epsilon]}
      end)

    multiply(gamma, epsilon)
  end

  defp multiply(gamma, epsilon) do
    {gamma, _} = Integer.parse(gamma |> Enum.join(""), 2)
    {epsilon, _} = Integer.parse(epsilon |> Enum.join(""), 2)

    gamma * epsilon
  end
end
