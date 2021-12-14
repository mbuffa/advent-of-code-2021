defmodule Day10Test do
  use ExUnit.Case

  alias Day10.PartOne
  alias Day10.PartOne.Node

  describe "part one" do
    test "1" do
      assert PartOne.parse(%Node{id: 0}, String.codepoints("()"), 0) == %Node{
        id: 0, opener: "(", terminator: ")", valid: true, children: []
      }
    end

    test "2" do
      assert PartOne.parse(%Node{id: 0}, String.codepoints("[]"), 0) == %Node{
        id: 0, opener: "[", terminator: "]", valid: true, children: []
      }
    end

    test "3" do
      assert PartOne.parse(%Node{id: 0}, String.codepoints("([])"), 0) == %Node{
        id: 0, opener: "(", terminator: ")", valid: true, children: [
          %Node{id: 1, opener: "[", terminator: "]", valid: true, children: []}
        ]
      }
    end

    test "4" do
      assert PartOne.parse(%Node{id: 0}, String.codepoints("{()()()}"), 0) == %Node{
        id: 0, opener: "{", terminator: "}", valid: true, children: [
          %Node{id: 1, opener: "(", terminator: ")", valid: true, children: []},
          %Node{id: 2, opener: "(", terminator: ")", valid: true, children: []},
          %Node{id: 3, opener: "(", terminator: ")", valid: true, children: []}
        ]
      }
    end

    test "5" do
      assert PartOne.parse(%Node{id: 0}, String.codepoints("<([{}])>"), 0) == %Node{
        id: 0, opener: "<", terminator: ">", valid: true, children: [
          %Node{id: 1, opener: "(", terminator: ")", valid: true, children: [
            %Node{id: 2, opener: "[", terminator: "]", valid: true, children: [
              %Node{id: 3, opener: "{", terminator: "}", valid: true, children: []}
            ]}
          ]}
        ]
      }
    end

    test "example" do
      assert PartOne.run("data/10/example.txt") == 26397
    end

    # test "input" do
    #   assert Day10.PartOne.run("data/10/input.txt") == nil
    # end
  end
end
