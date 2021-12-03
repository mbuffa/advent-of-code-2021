defmodule Day2Test do
  use ExUnit.Case

  describe "part_one" do
    test "example" do
      assert Day2.PartOne.run("data/2/example.txt") == 150
    end
  end

  describe "part_two" do
    test "example" do
      assert Day2.PartTwo.run("data/2/example.txt") == 900
    end
  end
end
