# Part 1
instructions =
  File.read('input.txt').
    split("\n").
    map { |line| line.split(' ') }.
    map { |d, n| [d, n.to_i] }

def add_to_path(path, position)
  path << position.join(',')
end

tail = [0, 0] # x1, y1
head = [0, 0] # x2, y2
path = add_to_path([], tail) # keys hold visited positions "x1,y1"

def move_head(head, dir, dist)
  head =
    case dir
    when 'R'
      [head[0] + dist, head[1]]
    when 'L'
      [head[0] - dist, head[1]]
    when 'U'
      [head[0], head[1] + dist]
    when 'D'
      [head[0], head[1] - dist]
    end
end

# a, b arrays each representing [x,y]
def distance(a, b)
  Math.sqrt((b[0] - a[0])**2 + (b[1] - a[1])**2)
end

def catch_up(tail, head, path = [])
  while distance(tail, head) > Math.sqrt(2)
    tail[1] += head[1] <=> tail[1]
    tail[0] += head[0] <=> tail[0]

    path = add_to_path(path, tail)
  end

  return [tail, path]
end

instructions.each do |dir, dist|
  head = move_head(head, dir, dist)
  tail, path = *catch_up(tail, head, path)
end

puts "Part 1 Result: #{path.uniq.count}"

# Part 2

TOTAL_KNOTS = 10
knots = TOTAL_KNOTS.times.map { [0,0] }
path = add_to_path([], knots.last)

instructions.each do |dir, dist|
  dist.times do
    knots[0] = move_head(knots[0], dir, 1)

    (1..(TOTAL_KNOTS - 2)).each do |i|
      knots[i], _ = *catch_up(knots[i], knots[i - 1])
    end

    knots[TOTAL_KNOTS - 1], path = *catch_up(knots[TOTAL_KNOTS - 1], knots[TOTAL_KNOTS - 2], path)
  end
end

puts "Part 2 Result: #{path.uniq.count}"
