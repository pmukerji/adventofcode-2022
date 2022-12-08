# Part 1:

require 'matrix'

forest = Matrix[*File.read('input.txt').split("\n").map { |line| line.split('').map(&:to_i) }]
depth = forest.row_size
width = forest.column_size

visibility_map = Array.new(depth) { Array.new(width) }

forest.each_with_index do |tree, row, col|
  if row == 0 || col == 0 || row == forest.row_size - 1 || col == forest.column_size - 1
    visibility_map[row][col] = true
  else
    visibility_map[row][col] =
      !forest[row, 0..(col - 1)].find { |other| other >= tree } ||
      !forest[row, (col + 1)..-1].find { |other| other >= tree } ||
      !forest.transpose[col, 0..(row - 1)].find { |other| other >= tree } ||
      !forest.transpose[col, (row + 1)..-1].find { |other| other >= tree }
  end
end

visible_trees = visibility_map.sum { |row| row.sum { |x| x ? 1 : 0 }}

puts "Part 1 Result: #{visible_trees}"

# Part 2:

scenic_map = Array.new(depth) { Array.new(width) }

forest.each_with_index do |tree, row, col|
  # Going out of bounds, at the edges, results in nil value
  left = forest[row, 0..(col - 1)].reverse
  right = forest[row, (col + 1)..-1]
  up = forest.transpose[col, 0..(row - 1)].reverse
  down = forest.transpose[col, (row + 1)..-1]

  scenic_map[row][col] =
    [left, right, up, down].map { |d| d || [] }.map do |dir|
      blocking_tree = dir.find { |other| other >= tree }
      if blocking_tree
        dir.index(blocking_tree) + 1
      else
        dir.size
      end
    end.inject(:*)
end

max_scenic_score = scenic_map.map(&:max).max

puts "Part 2 Result: #{max_scenic_score}"
