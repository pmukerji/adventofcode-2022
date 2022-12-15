# Part 1
class Sensor
  attr_reader :beacon, :x, :y

  def initialize(x, y, beacon)
    @x = x
    @y = y
    @beacon = beacon
  end

  def distance_to_beacon
   @distance_to_beacon ||= manhattan_distance(beacon.x, beacon.y)
  end

  def manhattan_distance(x1, y1)
    (y - y1).abs + (x - x1).abs
  end
end

class Beacon
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

readings = File.read('input.txt').split("\n")
regex = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/
sensors = []
beacons = []

readings.each do |r|
  coords = r.match(regex).to_a.map(&:to_i)
  beacons << beacon = Beacon.new(coords[3], coords[4])
  sensors << Sensor.new(coords[1], coords[2], beacon)
end

max_distance_to_beacon = sensors.map(&:distance_to_beacon).max
x_max = (sensors + beacons).map(&:x).max + max_distance_to_beacon
x_min = (sensors + beacons).map(&:x).min - max_distance_to_beacon

no_beacon = 0
x = x_min
ROW = 2000000

while x <= x_max do
  sensor =
    sensors.find do |s|
      s.manhattan_distance(x, ROW) <= s.distance_to_beacon
    end

  if sensor
    y_diff_abs = (sensor.y - ROW).abs
    x_new = sensor.x + sensor.distance_to_beacon - y_diff_abs + 1
    no_beacon += x_new - x
    x = x_new
  else
    x += 1
  end
end

no_beacon -= 1 if beacons.find { |b| b.y == ROW }

puts "Part 1 Result: #{no_beacon}"

# Part 2
distress_signal = []
x = 0
y = 0
MAX = 4000000

while y <= MAX do
  while x <= MAX do
    sensor =
      sensors.find do |s|
        s.manhattan_distance(x, y) <= s.distance_to_beacon
      end

    if sensor
      y_diff_abs = (sensor.y - y).abs
      x = sensor.x + sensor.distance_to_beacon - y_diff_abs
    elsif sensors.map { |s| s.manhattan_distance(x, y) > s.distance_to_beacon }.all?(true)
      distress_signal = [x, y]
      break
    end

    x += 1
  end

  x = 0
  y += 1
end

tuning_frequency = 4000000 * distress_signal[0] + distress_signal[1]

puts "Part 2 Result: #{tuning_frequency}"
