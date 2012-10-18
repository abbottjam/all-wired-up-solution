class Tree
  # Assumes definitions from
  # previous example...
  def to_s
    "[" +
    if left then left.to_s + "," else "" end +
    data.inspect +
    if right then "," + right.to_s else "" end + "]"
  end
  def to_a
    temp = []
    temp += left.to_a if left
    temp << data
    temp += right.to_a if right
    temp
  end
end

items = %w[bongo grimace monoid jewel plover nexus synergy]
tree = Tree.new
items.each {|x| tree.insert x}
str = tree.to_a * ","
# str is now "bongo,grimace,jewel,monoid,nexus,plover,synergy"
arr = tree.to_a
# arr is now:
# ["bongo",["grimace",[["jewel"],"monoid",[["nexus"],"plover",
# ["synergy"]]]]]

