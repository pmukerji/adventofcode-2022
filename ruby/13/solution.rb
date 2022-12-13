# Part 1:
class List
  attr_reader :items

  def initialize(data)
    @items = data.map do |item|
      case item
      when Integer
        ListInteger.new(item)
      when Array
        List.new(item)
      end
    end
  end

  def before?(item)
    case item
    when List
      list_comparison(item)
    when ListInteger
      self.before?(List.new([item.value]))
    end
  end

  def as_packet
    items.map(&:as_packet)
  end

  private

  def list_comparison(other_list)
    if items.empty? && !other_list.items.empty?
      return true
    end

    items.each_with_index do |item, i|
      if i > other_list.items.size - 1
        return false
      end

      comparison_result = item.before?(other_list.items[i])
      if [true, false].include?(comparison_result)
        return comparison_result
      end

      if (i == items.size - 1) && other_list.items.size > i + 1
        return true
      end
    end

    return nil
  end
end

class ListInteger
  attr_reader :value

  def initialize(integer)
    @value = integer
  end

  def before?(item)
    case item
    when List
      List.new([value]).before?(item)
    when ListInteger
      if value < item.value
        true
      elsif value > item.value
        false
      else
        nil
      end
    end
  end

  def as_packet
    value
  end
end

packet_pairs =
  File.read('input.txt').
    split("\n\n").map { |r| r.split("\n") }.
    map { |l, r| [List.new(eval(l)), List.new(eval(r))] }

packet_pairs.map { |left, right| left.before?(right) }.
  each_with_index. map { |order_correct, index| [index + 1, order_correct] }.
  select { |_, order_correct| order_correct }.map { |i, _| i }.
  sum

# Part 2

DIVIDER_1 = [[2]]
DIVIDER_2 = [[6]]

packets = [List.new(DIVIDER_1), List.new(DIVIDER_2)]
packet_pairs.each do |left, right|
  packets << left
  packets << right
end

sorted = packets.sort { |a, b| a.before?(b) ? -1 : 1 }
packets = sorted.map(&:as_packet)
decoder_key = (packets.find_index(DIVIDER_1) + 1) * (packets.find_index(DIVIDER_2) + 1)

puts "Part 2 Result: #{decoder_key}"
