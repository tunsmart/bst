# frozen_string_literal: true

class Node
  attr_accessor :data, :left, :right

  def initialize(value)
    @data = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :arr

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = nil
  end

  def build_tree(arr = @arr, start = 0, last = @arr.length - 1)
    if start > last
      nil
    else
      mid = (start + last) / 2
      root = Node.new(arr[mid])
      root.left = build_tree(arr, start, mid - 1)
      root.right = build_tree(arr, mid + 1, last)
      @root = root
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

def pre_order(node)
  if node.nil?
    nil
  else
    puts node.data
    pre_order(node.left)
    pre_order(node.right)
  end
end
arr = Array.new(15) { rand(1..100) }.uniq.sort
p arr
tree = Tree.new(arr)
root = tree.build_tree
p root
tree.pretty_print
