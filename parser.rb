require 'minitest/spec'
require 'minitest/autorun'

SYMBOLS = /[10AOXN]/

OPERATORS = ['A', 'O', 'X', 'N']
OPERANDS = ['1', '0']

class Circuit
  attr_reader :tree

  def initialize(file_path)
    File.open(file_path) do |f|
     res = ''
     f.readlines.each {|line|  res << line}
     res = res.split("\n")
     @tree = res.select! {|el| !el.eql? ''}
   end
 end

# -> string
def parse
  root_coor = find_root
  pos = move_left(root_coor)
  parse_tree(pos)
end

#position -> string
def parse_tree(pos, call=0)
  call += 1
  token = get(pos)
  return token if is_operand? token
  puts "CALL #{call}, POS: #{pos}"
  left = parse_left_subtree(pos, call)
  puts "CALL #{call}, POS: #{pos}"
  right = parse_right_subtree(pos, call) #pos is modified by the previous function call!
  ['(', left, token, right, ')'].join
end

#position -> procedure
def parse_left_subtree(pos, call)
  pos = move_up(pos)
  pos = move_left(pos)
  parse_tree(pos, call)
end

#position -> procedure
def parse_right_subtree(pos, call)
  pos = move_down(pos)
  pos = move_left(pos)
  parse_tree(pos, call)
end

#position -> boolean
def turn?(pos)
  get(pos).eql?('|') &&
  get(left(pos)).eql?('-')
end

#[x, y] -> token
def get(pos)
  #handle an exception here
  r = pos[:row]
  c = pos[:col]
  tree[r][c]
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

def move_left(pos)
  token = get(pos)
  return pos if is_symbol? token
  move_left(left(pos))
end

def move_up(pos)
  return pos if turn? pos
  move_up(up(pos))
end

def move_down(pos)
  return pos if turn? pos
  move_down(down(pos))
  #{:row => 2, :col => 14}
end

#position -> position
def left(pos)
  pos[:col] = pos[:col]-1
  pos
end

#position -> position
def up(pos)
  pos[:row] = pos[:row]-1
  pos
end

#position -> position
def down(pos)
  #puts "ROW: #{pos[:row]}"
  #puts "COL: #{pos[:col]}"
  pos[:row] = pos[:row]+1
  pos
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
describe "find root" do
  it "returns the coordinates" do
    @c.find_root.must_equal({:row => 3, :col => 40})
  end
end
describe "move left" do
  it "returns the coordinates of the first operator encountered" do
    root_coor = {:row => 3, :col => 40}
    @c.move_left(root_coor).must_equal({:row => 3, :col => 27})
  end
end
describe "parsing an operand - base case" do
  it "returns the operand" do
    coor = {:row => 0, :col => 0}
    #@c.parse_tree(coor).must_equal '0'
    coor = {:row => 2, :col => 0}
    #@c.parse_tree(coor).must_equal '1'
  end
end
describe "parsing an operator - recursive case" do
  it "returns the stringified expression" do
    coor = {:row => 1, :col => 14}
    @c.parse_tree(coor).must_equal '(0A1)'
  end
end
describe "meeting a turn" do
  it "returns true" do
    coor = {:row => 0, :col => 14}
    @c.turn?(coor).must_equal true
    coor = {:row => 2, :col => 14}
    @c.turn?(coor).must_equal true
  end
end


end
