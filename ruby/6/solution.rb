# Part 1

stream = File.open('input.txt').read.split('')

def parse_for_sequential_unique_characters(number, stream)
  processed = number
  validator = stream.slice!(0, number)

  while validator != validator.uniq
    processed += 1
    validator.slice!(0)
    validator.push(stream.slice!(0))
  end

  processed
end

start_of_packet_marker =
  parse_for_sequential_unique_characters(4, stream.dup)

puts "Part 1 Result: #{start_of_packet_marker}"

# Part 2

start_of_message_marker =
  parse_for_sequential_unique_characters(14, stream.dup)

puts "Part 2 Result: #{start_of_message_marker}"
