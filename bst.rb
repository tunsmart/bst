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

  def insert(value, node = @root)
    if node.nil?
      Node.new(value)
    else
      if value == node.data
        return node
      elsif value < node.data
        node.left = insert(value, node.left)
      else
        node.right = insert(value, node.right)
      end

      @root = node
    end
  end

  def delete(value, node = @root)
    removeHelper(value, node)
    @root = node
  end

  def find(value, node = @root)
    if node.nil?
      puts "Not found"
      return nil
    elsif value == node.data
      return node
    else
      node = find(value, node.left) if value < node.data
      node = find(value, node.right) if value > node.data
      return node
    end
  end

  def pre_order(node = @root)
    return nil if node.nil?

    puts node.data
    pre_order(node.left)
    pre_order(node.right)
  end

  def in_order(node = @root)
    return nil if node.nil?

    in_order(node.left)
    puts node.data
    in_order(node.right)
  end

  def post_order(node = @root)
    return nil if node.nil?

    post_order(node.left)
    post_order(node.right)
    puts node.data
  end

  def min_value(node)
    minv = node.data
    until node.left.nil?
      minv = node.data
      node = node.left
    end
    minv
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  # this helper method will avoid the multiple size decreses in recursion
  def removeHelper(value, node = @root)
    return nil if node.nil?

    if node.data > value
      node.left = removeHelper(value, node.left)
    elsif node.data < value
      node.right = removeHelper(value, node.right)
    elsif !node.left.nil? && !node.right.nil?
      temp = node
      node.data = min_value(node.right)
      node.right = removeHelper(node.value, node.right)
    elsif !node.left.nil?
      node = node.left
    elsif !node.right.nil?
      node = node.right
    else
      node = nil
    end
    node
  end
end
arr = Array.new(15) { rand(1..100) }.uniq.sort
p arr
tree = Tree.new(arr)
tree.build_tree
#tree.insert(1000)
# tree.insert(2)
tree.insert(4)
#tree.insert(200)
tree.pretty_print
p tree.find(arr[2])
