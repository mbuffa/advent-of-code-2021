defmodule Day6Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day6.PartOne.run("data/6/example.txt", 18) == 26
      assert Day6.PartOne.run("data/6/example.txt", 80) == 5934
    end
  end
end
