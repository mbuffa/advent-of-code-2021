defmodule Day4Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day4.PartOne.run("data/4/example.txt") == 4512
    end

    test "input" do
      assert Day4.PartOne.run("data/4/input.txt") == 72770
    end
  end
end
