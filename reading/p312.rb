class Tree
  # Assumes definitions
  # from previous example...
  def search(x)
    if self.data == x
      return self
    elsif x < self.data
      return left ? left.search(x) : nil
    else
      return right ? right.search(x) : nil
    end
  end
end

keys = [50, 20, 80, 10, 30, 70, 90, 5, 14,
        28, 41, 66, 75, 88, 96]
tree = Tree.new
keys.each {|x| tree.insert(x)}
s1 = tree.search(75)   # Returns a reference to the node
                       # containing 75...
s2 = tree.search(100)  # Returns nil (not found)

