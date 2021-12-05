defmodule Day3.PartTwo do
  defmodule Data do
    defstruct [:raw]
  end

  def run(filename) do
    data = Day3.PartOne.read(filename)

    %{o2: o2, co2: co2} =
      data.raw
      |> Enum.with_index()
      |> Enum.reduce(%{o2: data.raw, co2: data.raw}, fn {_raw_data, index}, acc ->
        o2_numbers = filter_bits(acc.o2, index, :majority, "1")
        co2_numbers = filter_bits(acc.co2, index, :minority, "0")

        %{acc | o2: o2_numbers, co2: co2_numbers}
      end)

    {o2, _} =
      Integer.parse(o2 |> Enum.join(""), 2)
    {co2, _} =
      Integer.parse(co2 |> Enum.join(""), 2)

    o2 * co2
  end

  defp filter_bits(numbers, index, prefered_strategy, prefered_value)

  # Only one number remaining:
  defp filter_bits([_] = numbers, _, _, _) do
    numbers
  end

  # Only two numbers remaining:
  defp filter_bits([_, _] = numbers, index, _, prefered_value) do
    Enum.filter(numbers, & Enum.at(&1, index) == prefered_value)
  end

  defp filter_bits(numbers, index, prefered_strategy, prefered_value) do
    current_column =
      Enum.zip(numbers)
      |> Enum.at(index)

    frequencies =
      current_column
      |> Tuple.to_list()
      |> Enum.frequencies()

    cond do
      prefered_strategy == :majority and frequencies["0"] > frequencies["1"] ->
        Enum.filter(numbers, & Enum.at(&1, index) == "0")

      prefered_strategy == :majority and frequencies["0"] < frequencies["1"] ->
        Enum.filter(numbers, & Enum.at(&1, index) == "1")

      prefered_strategy == :minority and frequencies["0"] < frequencies["1"] ->
        Enum.filter(numbers, & Enum.at(&1, index) == "0")

      prefered_strategy == :minority and frequencies["0"] > frequencies["1"] ->
        Enum.filter(numbers, & Enum.at(&1, index) == "1")

      frequencies["0"] == frequencies["1"] ->
        Enum.filter(numbers, & Enum.at(&1, index) == prefered_value)
    end
  end
end
