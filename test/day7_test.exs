defmodule Day7Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day7.PartOne.run("data/7/example.txt") == 37
    end

    test "input" do
      assert Day7.PartOne.run("data/7/input.txt") == 335330
    end
  end

  describe "part two" do
    test "example" do
      assert Day7.PartTwo.run("data/7/example.txt") == 168
    end

    test "input" do
      assert Day7.PartTwo.run("data/7/input.txt") == 92439766
    end
  end
end
