# frozen_string_literal: true

require 'pry-byebug'
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
      puts 'Not found'
      nil
    elsif value == node.data
      node
    else
      node = find(value, node.left) if value < node.data
      node = find(value, node.right) if value > node.data
      node
    end
  end

  def depth(value, root = @root, level = 0)
    return nil if root.nil?

    if value == root.data
      level
    elsif value < root.data
      depth(value, root.left, level += 1)
    elsif value > root.data
      depth(value, root.right, level += 1)
    end
  end

  def height(node = @root)
    return -1 if node.nil?

    left_h = height(node.left)
    right_h = height(node.right)

    left_h > right_h ? left_h + 1 : right_h + 1
  end

  def balanced?
    left_tree_height = height(@root.left)
    right_tree_height = height(@root.right)
    (left_tree_height - right_tree_height).abs <= 1
  end

  def rebalance
    arr = in_order
    @root = nil
    build_tree(arr, 0, arr.length - 1)
  end

  def level_order(node = @root)
    return nil if node.nil?

    result = []
    queue = []
    queue << node
    until queue.empty?
      node = queue[0]
      block_given? ? yield(node.data) : result << node.data
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
      queue.shift
    end
    result unless block_given?
  end

  def pre_order(node = @root, result = [], &block)
    return nil if node.nil?

    block ? block.call(node.data) : result << node.data
    pre_order(node.left, result, &block)
    pre_order(node.right, result, &block)
    return result unless block_given?
  end

  def in_order(node = @root, result = [], &block)
    return nil if node.nil?

    in_order(node.left, result, &block)
    block ? block.call(node.data) : result << node.data
    in_order(node.right, result, &block)
    return result unless block_given?
  end

  def post_order(node = @root, result = [], &block)
    return nil if node.nil?

    post_order(node.left, result, &block)
    post_order(node.right, result, &block)
    block ? block.call(node.data) : result << node.data
    return result unless block_given?
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def min_value(node)
    minv = node.data
    until node.left.nil?
      minv = node.data
      node = node.left
    end
    minv
  end

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
arr = Array.new(30) { rand(1..100) }.uniq.sort
p arr
tree = Tree.new(arr)
tree.build_tree
p tree.balanced?
tree.insert(1000)
tree.insert(200)
tree.insert(300)
tree.insert(500)
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.balanced?
