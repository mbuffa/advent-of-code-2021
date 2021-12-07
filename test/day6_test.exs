defmodule Day6Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day6.PartOne.run("data/6/example.txt", 18) == 26
      assert Day6.PartOne.run("data/6/example.txt", 80) == 5934
    end

    test "input" do
      assert Day6.PartOne.run("data/6/input.txt", 80) == 359344
    end
  end

  describe "part two" do
    test "example" do
      assert Day6.PartTwo.run("data/6/example.txt", 256) == 26984457539
    end
  end
end
