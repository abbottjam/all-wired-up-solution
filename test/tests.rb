require_relative "../lib/evaluator.rb"
require_relative "../lib/parser.rb"
require_relative "../circuit_solver.rb"

require 'minitest/spec'
require 'minitest/autorun'

describe "evaluator tests" do
  describe "transforming input sequence" do
    it "substitutes symbols with values" do
      transform('((0A1)X(N1))').must_equal '((false&&true)^(!true))'
    end
  end

  describe "evaling sequence" do
    it "evals expression to value" do
      eval('((false&&true)^(!true))').must_equal false
    end
  end

  describe "the whole thing" do
    it "just works" do
      eval(transform('((0A1)X(N1))')).must_equal false
    end
  end
end

describe "parser tests" do
  describe "parsing the symbol tree" do
   before do
    @c = Circuit.new('./files/input/example.txt')
  end

  describe "finding the root" do
    it "returns the coordinates" do
      @c.find_root.must_equal({:row => 3, :col => 40})
    end
  end

  describe "moving left" do
    it "returns the coordinates of the first operator encountered" do
      root_coor = {:row => 3, :col => 40}
      @c.move_left(root_coor).must_equal({:row => 3, :col => 27})
    end
  end

  describe "parsing an operand - base case" do
    it "returns the operand" do
      @c.parse_tree({:row => 0, :col => 0}).must_equal '0'
      @c.parse_tree({:row => 2, :col => 0}).must_equal '1'
    end
  end

  describe "parsing an operator - recursive case" do
    it "returns the stringified expression" do
      @c.parse_tree({:row => 1, :col => 14}).must_equal '(0A1)'
    end
  end

  describe "when meeting a turn: -|" do
    it "recognizes a turn" do
      @c.turn?({:row => 0, :col => 14}).must_equal true
      @c.turn?({:row => 2, :col => 14}).must_equal true
    end
  end

  describe "addressing individual tokens with get(pos)" do
    it "returns the token or nil" do
      pos = {:row => 5, :col => 14}
      @c.get(pos).must_equal 'N'
      above = @c.up(pos)
      @c.get(above).must_equal '|'
      below = @c.down(pos)
      @c.get(below).must_equal nil
    end
  end

  describe "meeting a subtree" do
    it "recognizes subtree" do
      @c.left_subtree?({:row => 5, :col => 14}).must_equal true
    end
    it "recogizes missing subtree - edge case" do
      @c.right_subtree?({:row => 5, :col => 14}).must_equal false
    end
  end

  describe "parsing the whole tree" do
    it "returns the stringified expression" do
      @c.parse.must_equal '((0A1)X(N1))'
    end
  end

  describe "parsing simple circuits" do
    it "parses single circuits to correct parenthesized expressions" do
      Circuit.new('./files/input/simple-1.txt').parse.must_equal '(0O1)'
      Circuit.new('./files/input/simple-2.txt').parse.must_equal '((0A1)X(N1))'
      Circuit.new('./files/input/simple-3.txt').parse.must_equal '((0O1)X(1X1))'
    end
    it "parses several circuits to correct parenthesized expressions" do
      Circuit.new('./files/input/simple_circuits.txt').parse_all.must_equal ['(0O1)', '((0A1)X(N1))', '((0O1)X(1X1))']
    end
  end
end

describe "driver tests" do
  describe "simple circuits evaluate to correct output" do
  it "works" do
    resolve('./files/input/simple_circuits.txt').must_equal ['on', 'off', 'on']
  end
end

describe "complex circuits evaluate to correct output" do
  it "works, too" do
    resolve('./files/input/complex_circuits.txt').must_equal ["on", "on", "on", "off", "off", "on", "on", "off"]
  end
end
end
end
