# Part 1

require 'csv'
pairs = CSV.read('input.txt')

pairs.count do |a, b|
  a = a.split('-')
  b = b.split('-')

  series_a = (a[0]..a[1]).to_a
  series_b = (b[0]..b[1]).to_a

  (series_a - series_b).empty? || (series_b - series_a).empty?
end

# Part 2

pairs.count do |a, b|
  a = a.split('-')
  b = b.split('-')

  series_a = (a[0]..a[1]).to_a
  series_b = (b[0]..b[1]).to_a

  !series_a.intersection(series_b).empty?
end
