# Part 1

input = File.open('input.txt').read

raw_stacks = input.split("\n\n")[0]

def starting_stacks(raw_stacks)
  raw_stacks.split("\n")[0..-2].map { |row|
    row.split('').drop(1).each_slice(4).map(&:first)
  }.transpose.map(&:reverse).map { |tmp_stack|
    tmp_stack.select { |crate| crate != ' ' }
  }
end

stacks = starting_stacks(raw_stacks)

raw_instructions = input.split("\n\n")[1].split("\n")

instructions = raw_instructions.map { |i|
  extract = /move (?<move>.+) from (?<from>.+) to (?<to>.+)/.match(i)
  [extract['move'], extract['from'], extract['to']].map(&:to_i)
}

instructions.each do |move, from, to|
  move.times do
    crate = stacks[from - 1].pop
    stacks[to - 1].push(crate)
  end
end

top_of_each_stack = stacks.map(&:last).join('')

puts "Part 1 Result: #{top_of_each_stack}"

# Part 2

stacks = starting_stacks(raw_stacks)

instructions.each do |move, from, to|
  crates = stacks[from - 1].pop(move)
  stacks[to - 1].push(*crates)
end

top_of_each_stack = stacks.map(&:last).join('')

puts "Part 2 Result: #{top_of_each_stack}"
