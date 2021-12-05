defmodule Day3Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day3.PartOne.run("data/3/example.txt") == 198
    end
  end

  describe "part two" do
    test "example" do
      assert Day3.PartTwo.run("data/3/example.txt") == 230
    end

    test "input" do
      assert Day3.PartTwo.run("data/3/input.txt") == 6677951
    end
  end
end
