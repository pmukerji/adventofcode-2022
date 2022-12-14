# Part 1:
require 'rainbow'

elevation_map =
  File.read('input.txt').
    split("\n").
    map { |row| row.split('') }

# S = current position
# E = best signal (at elevation z)

class Node
  attr_reader :elevation, :connections, :distance_to_goal, :position

  def initialize(x, y, elevation)
    @x = x
    @y = y
    @position = [x, y]
    @elevation = elevation
    @connections = []
    @distance_to_goal = Float::INFINITY
    @visited = false
  end

  def connect(node)
    @connections << node.position
  end

  def set_distance_to_goal(distance)
    if distance < @distance_to_goal
      @distance_to_goal = distance
    end
  end

  def set_as_visited!
    @visited = true
  end

  def not_visited?
    !@visited
  end

  def can_move_to?(other)
    (other.elevation.ord - elevation.ord) <= 1
  end
end

def draw_distance_map(nodes)
  nodes.each_with_index do |row, i|
    row.each_with_index do |node, j|
      if node.distance_to_goal == Float::INFINITY
        print "--- "
      else
        print "#{"%03d" % node.distance_to_goal} "
      end
    end
    puts "\n"
  end
end

# https://colordesigner.io/gradient-generator
COLORS = {
  'a' => '#3d2dbb',
  'b' => '#5126b4',
  'c' => '#601ead',
  'd' => '#6c14a6',
  'e' => '#76059e',
  'f' => '#7e0097',
  'g' => '#85008f',
  'h' => '#8b0087',
  'i' => '#90007f',
  'j' => '#940078',
  'k' => '#980070',
  'l' => '#9a0069',
  'm' => '#9c0062',
  'n' => '#9e005b',
  'o' => '#9e0054',
  'p' => '#9f004d',
  'q' => '#9e0047',
  'r' => '#9e0040',
  's' => '#9d003a',
  't' => '#9b0035',
  'u' => '#9a002f',
  'v' => '#98002a',
  'w' => '#950025',
  'x' => '#930320',
  'y' => '#900f1c',
  'z' => '#8d1717',
}

def draw_elevation_map(nodes)
  nodes.each_with_index do |row, i|
    row.each_with_index do |node, j|
      print "#{Rainbow(node.elevation).color(COLORS[node.elevation])} "
    end
    puts "\n"
  end
end


height = elevation_map.size
width = elevation_map.first.size
nodes = Array.new(height) { Array.new(width) }
start = []
goal = []
EDGE_COST = 1

# Build nodes
elevation_map.each_with_index do |row, i|
  row.each_with_index do |elevation, j|
    case elevation
    when 'S'
      start = [i, j]
      elevation = 'a'
    when 'E'
      goal = [i, j]
      elevation = 'z'
    end

    nodes[i][j] = Node.new(i, j, elevation)
  end
end

# Connect nodes
nodes.each_with_index do |row, i|
  row.each_with_index do |node, j|
    if i > 0 && nodes[i - 1][j].can_move_to?(node)
      node.connect(nodes[i - 1][j])
    end

    if i < (height - 1) && nodes[i + 1][j].can_move_to?(node)
      node.connect(nodes[i + 1][j])
    end

    if j > 0 && nodes[i][j - 1].can_move_to?(node)
      node.connect(nodes[i][j - 1])
    end

    if j < (width - 1) && nodes[i][j + 1].can_move_to?(node)
      node.connect(nodes[i][j + 1])
    end
  end
end

current_node = nodes[goal[0]][goal[1]]
current_node.set_distance_to_goal(0)

while current_node do
  current_node.connections.each do |position|
    node = nodes[position[0]][position[1]]
    if node.not_visited?
      node.set_distance_to_goal(current_node.distance_to_goal + EDGE_COST)
    end
  end

  current_node.set_as_visited!
  current_node = nodes.flatten.select(&:not_visited?).sort_by(&:distance_to_goal).first
end

start_node = nodes[start[0]][start[1]]

puts "Part 1 Result: #{start_node.distance_to_goal}"

draw_elevation_map(nodes)

# Part 2

shortest_path_from_an_a =
  nodes.flatten.select { |n| n.elevation == 'a' }.map(&:distance_to_goal).min

puts "Part 2 Result: #{shortest_path_from_an_a}"

draw_distance_map(nodes)
