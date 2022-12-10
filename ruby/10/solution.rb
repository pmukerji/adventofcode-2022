# Part 1
#
instructions =
  File.read('input.txt').
    split("\n").
    map { |line| line.split(' ') }

x = 1
cycle_count = 0
signal_strength = []

instructions.each do |command, value|
  case command
  when 'noop'
    cycle_count += 1
    signal_strength << cycle_count * x
  when 'addx'
    cycle_count += 1
    signal_strength << cycle_count * x
    cycle_count += 1
    signal_strength << cycle_count * x
    x += value.to_i
  end
end

signal_sum =
  signal_strength[19] +
    signal_strength[59] +
    signal_strength[99] +
    signal_strength[139] +
    signal_strength[179] +
    signal_strength[219]

puts "Part 1 Result: #{signal_sum}"

# Part 2

SCREEN_WIDTH = 40
SCREEN_HEIGHT = 6
screen = Array.new(SCREEN_HEIGHT) { Array.new(SCREEN_WIDTH, '.') }

cycle_count = 0
x = 1

def draw(screen)
  puts "Screen:"

  screen.each do |row|
    puts row.join('')
  end

  puts "\n"
end

def light_up(cycle_count, x, screen)
  puts "Cycle: #{cycle_count}"

  screen_point = cycle_count % SCREEN_WIDTH
  screen_line = Array.new(40, '.')
  screen_line[screen_point - 1] = '#'
  puts "Screen Line:"
  puts screen_line.join('')

  sprite = Array.new(40, '.')
  sprite[(x-1)..(x+1)] = ['#', '#', '#']
  puts "Sprite:"
  puts sprite.join('')

  if [x - 1, x, x + 1].include?(screen_point - 1)
    screen[cycle_count / SCREEN_WIDTH][screen_point - 1] = '#'
  end

  draw(screen)

  screen
end

instructions.each do |command, value|
  case command
  when 'noop'
    cycle_count += 1
    screen = light_up(cycle_count, x, screen)
  when 'addx'
    cycle_count += 1
    screen = light_up(cycle_count, x, screen)
    cycle_count += 1
    screen = light_up(cycle_count, x, screen)
    x += value.to_i
  end
end
