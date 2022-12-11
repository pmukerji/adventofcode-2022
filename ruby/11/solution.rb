# Part 1

class Item
  attr_reader :worry_level

  def initialize(worry_level)
    @worry_level = worry_level
  end

  def update_worry_level(new_worry_level)
    @worry_level = new_worry_level
  end

  def handle_relief(action, value)
    update_worry_level(worry_level.send(action, value))
  end
end

class Monkey
  attr_reader :items, :name, :test_divisible_by

  def initialize(raw_monkey_info)
    lines = raw_monkey_info.split("\n")

    @name = lines[0].match(/(\d+)/)[0].to_i
    @items =
      lines[1].split(': ')[1].split(', ').map(&:to_i)
        .map { |w| Item.new(w) }
    @operation = lines[2].split('new = old ')[1].split(' ')
    @test_divisible_by = lines[3].match(/(\d+)/)[0].to_i
    @test = {
      true => lines[4].match(/(\d+)/)[0].to_i,
      false => lines[5].match(/(\d+)/)[0].to_i
    }
  end

  def inspect_next_item
    new_worry_level = calculate_worry_level_from_inspection(items[0])

    items[0].update_worry_level(new_worry_level)
  end

  def target_for_worry_level
    @test[items[0].worry_level % @test_divisible_by == 0 ]
  end

  def throw_next_item
    items.slice!(0)
  end

  def receive_item(item)
    items << item
  end

  private

  def calculate_worry_level_from_inspection(item)
    worry_level = item.worry_level

    case @operation[1]
    when 'old'
      worry_level.send(@operation[0], worry_level)
    else
      worry_level.send(@operation[0], @operation[1].to_i)
    end
  end
end

def draw_round(round, monkeys)
  puts "Round: #{round}"
  monkeys.each do |monkey|
    puts "Monkey #{monkey.name}: #{monkey.items.map(&:worry_level).join(', ')}"
  end
  puts "\n"
end

monkeys =
  File.read('input.txt').
    split("\n\n").
    map { |data| Monkey.new(data) }

inspected_items = (0..monkeys.size - 1).map { |k| [k, 0] }.to_h

(1..20).each do |round|
  monkeys.each_with_index do |monkey, i|
    item_count = monkey.items.size
    inspected_items[i] += item_count
    item_count.times do
      monkey.inspect_next_item
      monkey.items.first.handle_relief('/', 3)
      target_monkey = monkeys[monkey.target_for_worry_level]
      target_monkey.receive_item(monkey.throw_next_item)
    end
  end
end

inspected_counts = inspected_items.map { |k, v| v }.sort.reverse
monkey_business = inspected_counts[0] * inspected_counts[1]

puts "Part 1 Result: #{monkey_business}"

# Part 2

monkeys =
  File.read('input.txt').
    split("\n\n").
    map { |data| Monkey.new(data) }

divisors = monkeys.map(&:test_divisible_by)
lcm = divisors.inject(1, :*)

inspected_items = (0..monkeys.size - 1).map { |k| [k, 0] }.to_h

(1..10000).each do |round|
  monkeys.each_with_index do |monkey, i|
    item_count = monkey.items.size
    inspected_items[i] += item_count
    item_count.times do
      monkey.inspect_next_item
      monkey.items.first.handle_relief('%', lcm)
      target_monkey = monkeys[monkey.target_for_worry_level]
      target_monkey.receive_item(monkey.throw_next_item)
    end
  end
end

inspected_counts = inspected_items.map { |k, v| v }.sort.reverse
monkey_business = inspected_counts[0] * inspected_counts[1]

puts "Part 2 Result: #{monkey_business}"
