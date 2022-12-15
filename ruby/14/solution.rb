# Part 1
require 'rainbow'

class Cave
  SYMBOLS = {
    'rock' => '#',
    'air' => '.',
    'sand' => 'o'
  }

  COLORS = {
    'o' => '#919155',
    '.' => '#324758',
    '#' => '#FFFFFF'
  }

  attr_reader :grid

  def initialize(height, width)
    @grid = Array.new(height) { Array.new(width, SYMBOLS['air']) }
  end

  def add_rock_path(rock_path)
    @cached_rock_coordinates = nil
    rock_path.each_with_index do |coords, i|
      add_rock_line(coords, rock_path[i + 1]) if rock_path.size > i + 1
    end
  end

  def add_floor
    y = rock_coordinates.map(&:last).max + 2
    size = grid[y].size
    grid[y] = Array.new(size, SYMBOLS['rock'])
  end

  def settle(sand)
    x = sand.x
    y = sand.y
    @grid[y][x] = SYMBOLS['sand']
  end

  def rock_coordinates
    return @cached_rock_coordinates if @cached_rock_coordinates

    @cached_rock_coordinates = coordinates_for('rock')
  end

  def coordinates_for(type)
    coordinates = []
    grid.each_with_index do |row, y|
      row.each_with_index do |material, x|
        if grid[y][x] == SYMBOLS[type]
          coordinates << [x, y]
        end
      end
    end

    coordinates
  end

  def draw
    min_x = [
      0,
      grid.map { |row| row.find_index { |x| x != '.' } || row.size - 1 }.min - 1
    ].max

    puts "Cave:"
    grid.each do |row|
      puts row[min_x..-1].map { |v| Rainbow(v).color(COLORS[v]) }.join('')
    end
  end

  private

  def add_rock_line(from, to)
    if from[0] == to[0]
      x = from[0]
      range =
        from[1] < to[1] ? from[1]..to[1] : to[1]..from[1]
      range.each { |y| @grid[y][x] = '#' }
    elsif from[1] == to[1]
      y = from[1]
      range =
        from[0] < to[0] ? from[0]..to[0] : to[0]..from[0]
      range.each { |x| @grid[y][x] = '#' }
    end
  end
end

class Sand
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def can_move?(cave, free_space)
    cave.grid[y + 1][x] == free_space ||
      cave.grid[y + 1][x - 1] == free_space ||
      cave.grid[y + 1][x + 1] == free_space
  end

  def move(cave, free_space, void: true)
    if void && @y >= cave.rock_coordinates.map(&:last).max
      return nil
    end

    if cave.grid[y + 1][x] == free_space
      @y += 1
    elsif cave.grid[y + 1][x - 1] == free_space
      @y += 1
      @x -= 1
    elsif cave.grid[y + 1][x + 1] == free_space
      @y += 1
      @x += 1
    else
      return false
    end
  end
end

raw_rock_paths =
  File.read('input.txt').split("\n")

rock_paths =
  raw_rock_paths.map { |path|
    path.split(' -> ').map { |c|
      c.split(',').map(&:to_i) } }

all_coordinates = rock_paths.inject(:+)
width = all_coordinates.map(&:first).max + 1 + 1
height = all_coordinates.map(&:last).max + 1 + 1
cave = Cave.new(height, width)
rock_paths.each { |path| cave.add_rock_path(path) }

SAND_ORIGIN = [500, 0]

void_not_reached = true
while void_not_reached do
  sand = Sand.new(*SAND_ORIGIN)
  while sand.can_move?(cave, Cave::SYMBOLS['air'])
    result = sand.move(cave, Cave::SYMBOLS['air'])
    if result == nil
      void_not_reached = false
      break
    end
  end
  cave.settle(sand) if void_not_reached
end

settled_sand_count = cave.coordinates_for('sand').count

puts "Part 1 Result: #{settled_sand_count}"

cave.draw

# Part 2

cave = Cave.new(height + 2, width * 2)
rock_paths.each { |path| cave.add_rock_path(path) }
cave.add_floor

origin_clear = true
while origin_clear do
  sand = Sand.new(*SAND_ORIGIN)

  if !sand.can_move?(cave, Cave::SYMBOLS['air'])
    origin_clear = false
  end

  while sand.can_move?(cave, Cave::SYMBOLS['air'])
    sand.move(cave, Cave::SYMBOLS['air'], void: false)
  end

  cave.settle(sand)
end

settled_sand_count = cave.coordinates_for('sand').count

puts "Part 2 Result: #{settled_sand_count}"

cave.draw
