require 'minitest/spec'
require 'minitest/autorun'

OPERATORS = ['A', 'O', 'X', 'N']
OPERANDS = ['1', '0']

class Circuit
  attr_reader :tree

  def initialize(file_path)
    @tree = IO.read(file_path).split("\n")
    @tree.select! {|line| !line.empty?} if @tree.include? ""
  end

# -> string
def parse
  parse_tree(move_left(find_root))
end

# -> position
def find_root
  tree.each_with_index do |str, i|
    if str.match '@'
      y = str.index '@'
      return {:row => i, :col => y}
    end
  end
end

#position -> string
def parse_tree(pos)
  token = get(pos)
  return token if is_operand? token
  left = parse_left_subtree(pos)
  right = parse_right_subtree(pos)
  ['(', left, token, right, ')'].join
end

#position -> procedure or string
def parse_left_subtree(pos)
  if left_subtree? pos
    parse_tree(move_left(move_up(pos)))
  else
    ''
  end
end

#position -> procedure or string
def parse_right_subtree(pos)
  if right_subtree? pos
    parse_tree(move_left(move_down(pos)))
  else
    ''
  end
end

#position -> boolean
def left_subtree?(pos)
  !get(up(pos)).eql? nil
end

#position -> boolean
def right_subtree?(pos)
  !get(down(pos)).eql? nil
end

#position -> token or nil
def get(pos)
  r = pos[:row]
  c = pos[:col]
  begin
    tree[r][c]
  rescue Exception => e
    puts e.message
  end
end

#position -> position or procedure
def move_left(pos)
  token = get(pos)
  return pos if is_symbol? token
  move_left(left(pos))
end

#position -> position or procedure
def move_up(pos)
  return pos if turn? pos
  move_up(up(pos))
end

#position -> position or procedure
def move_down(pos)
  return pos if turn? pos
  move_down(down(pos))
end

#position -> boolean
def turn?(pos)
  get(pos).eql?('|') &&
  get(left(pos)).eql?('-')
end

#position -> position
def left(pos)
  {
    :row => pos[:row],
    :col => pos[:col]-1
  }
end

#position -> position
def up(pos)
  {
    :row => pos[:row]-1,
    :col => pos[:col]
  }
end

#position -> position
def down(pos)
  {
    :row => pos[:row]+1,
    :col => pos[:col]
  }
end

def is_operator?(token)
  OPERATORS.include? token
end

def is_operand?(token)
  OPERANDS.include? token
end

def is_symbol?(token)
  is_operator?(token) || is_operand?(token)
end
end

describe "parsing the symbol tree" do
 before do
  @c = Circuit.new('files/example.txt')
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
    @c.parse.must_equal '((0A1)X(1N))'
  end
end
describe "parsing simple circuits" do
  it "parses to correct parenthesized expressions" do
    Circuit.new('files/simple-1.txt').parse.must_equal '(0O1)'
    Circuit.new('files/simple-2.txt').parse.must_equal '((0A1)X(1N))'
    Circuit.new('files/simple-3.txt').parse.must_equal '((0O1)X(1X1))'
  end
end
end
