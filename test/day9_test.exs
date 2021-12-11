defmodule Day9Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day9.PartOne.run("data/9/example.txt") == 15
    end

    test "input" do
      assert Day9.PartOne.run("data/9/input.txt") == 526
    end
  end

  describe "part two" do
    test "example" do
      assert Day9.PartTwo.run("data/9/example.txt") == 1134
    end

    test "input" do
      assert Day9.PartTwo.run("data/9/input.txt") == 1123524
    end
  end
end
