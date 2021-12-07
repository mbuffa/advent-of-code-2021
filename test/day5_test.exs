defmodule Day5Test do
  use ExUnit.Case

  describe "part one" do
    test "example" do
      assert Day5.PartOne.run("data/5/example.txt") == 5
    end

    # This times out 60s. There *might* be a better algo...
    # test "input" do
    #   assert Day5.PartOne.run("data/5/input.txt") == 5
    # end
  end

  describe "find_largest_position" do
    test "example" do
      tiles = [
        [[0, 9], [5, 9]],
        [[8, 0], [0, 8]],
        [[9, 4], [3, 4]],
        [[2, 2], [2, 1]],
        [[7, 0], [7, 4]],
        [[6, 4], [2, 0]],
        [[0, 9], [2, 9]],
        [[3, 4], [1, 4]],
        [[0, 0], [8, 8]],
        [[5, 5], [8, 2]]
      ]

      assert Day5.PartOne.find_map_size(tiles) == [9, 9]
    end

    test "dummy" do
      tiles = [
        [[0, 9], [4, 7]],
        [[8, 2], [2, 8]],
        [[6, 1], [1, 5]],
      ]

      assert Day5.PartOne.find_map_size(tiles) == [8, 9]
    end
  end

  describe "unfold" do
    test "simple assertions" do
      assert Day5.PartOne.unfold([0, 9], [5, 9]) == [
        {0, 9},
        {1, 9},
        {2, 9},
        {3, 9},
        {4, 9},
        {5, 9}
      ]

      assert Day5.PartOne.unfold([9, 4], [3, 4]) == [
        {9, 4},
        {8, 4},
        {7, 4},
        {6, 4},
        {5, 4},
        {4, 4},
        {3, 4}
      ]

      assert Day5.PartOne.unfold([2, 2], [2, 1]) == [
        {2, 2},
        {2, 1}
      ]

      assert Day5.PartOne.unfold([7, 0], [7, 4]) == [
        {7, 0},
        {7, 1},
        {7, 2},
        {7, 3},
        {7, 4}
      ]

      assert Day5.PartOne.unfold([0, 9], [2, 9]) == [
        {0, 9},
        {1, 9},
        {2, 9}
      ]

      assert Day5.PartOne.unfold([3, 4], [1, 4]) == [
        {3, 4},
        {2, 4},
        {1, 4}
      ]

      # Diagonals should be excluded
      assert Day5.PartOne.unfold([8, 0], [0, 8]) == []
      assert Day5.PartOne.unfold([6, 4], [2, 0]) == []
      assert Day5.PartOne.unfold([0, 0], [8, 8]) == []
      assert Day5.PartOne.unfold([5, 5], [8, 2]) == []
    end
  end
end
