defmodule Day8Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day8.PartOne.run("data/8/example.txt") == 26
    end

    test "input" do
      assert Day8.PartOne.run("data/8/input.txt") == 237
    end
  end
end
