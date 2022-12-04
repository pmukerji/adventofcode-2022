input = File.open('input.txt').read

# Part 1
elves = input.split("\n\n")
calories_per_elf = elves.map { |elf| elf.split("\n").map(&:to_i).sum }
most_calories = calories_per_elf.max
puts "Part 1 Result: #{most_calories}"

# Part 2
top_3_total_calories = calories_per_elf.sort.reverse[0..2].sum
puts "Part 2 Result: #{top_3_total_calories}"
