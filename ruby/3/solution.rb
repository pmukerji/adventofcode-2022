# Part 1

PRIORITY = ('a'..'z').to_a + ('A'..'Z').to_a

input = File.open('input.txt').read
backpacks = input.split("\n")

priorities =
  backpacks.map do |backpack|
    size = backpack.size
    compartment_a = backpack.slice(0, size / 2).split('')
    compartment_b = backpack.slice(size / 2, size / 2).split('')
    overlap = compartment_a.intersection(compartment_b).first

    PRIORITY.find_index(overlap) + 1
  end

puts "Part 1 Result: #{priorities.sum}"

# Part 2

priorities =
  backpacks.each_slice(3).map do |a, b, c|
    overlap = a.split('').intersection(b.split(''), c.split('')).first

    PRIORITY.find_index(overlap) + 1
  end

puts "Part 2 Result: #{priorities.sum}"
