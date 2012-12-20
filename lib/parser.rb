
OPERATORS = ['A', 'O', 'X', 'N']
OPERANDS = ['1', '0']

class Circuit
  attr_reader :tree

  def initialize(file_path)
    @tree = IO.read(file_path).split("\n")
  end

# -> string
def parse
  parse_tree(move_left(find_root))
end

# array -> string
def parse_all
  find_roots.map do |coor|
    parse_tree(move_left(coor))
  end
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

# -> array of positions
def find_roots
  roots = []
  tree.each_with_index do |str, i|
    if str.match '@'
      y = str.index '@'
      roots << {:row => i, :col => y}
    end
  end
  roots
end

#position -> string
def parse_tree(pos)
  token = get(pos)
  return token if is_operand? token
  left = parse_left_subtree(pos)
  right = parse_right_subtree(pos)
  if token.eql? 'N'
    ['(', token, left, right, ')'].join #preorder
  else
    ['(', left, token, right, ')'].join #inorder
  end
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
  get(up(pos)).eql? '|'
end

#position -> boolean
def right_subtree?(pos)
  get(down(pos)).eql? '|'
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
