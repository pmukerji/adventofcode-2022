# Part 1

class Shape
  include Comparable
  STRONGER_SHAPE_COMPARISONS = [['Rock', 'Scissors'], ['Paper', 'Rock'], ['Scissors', 'Paper']]
  SHAPE_POINT_MAPPING = {
    'Rock' => 1,
    'Paper' => 2,
    'Scissors' => 3
  }
  attr :type

  def initialize(type)
    @type = type
  end

  def <=>(other)
    if type == other.type
      0
    elsif STRONGER_SHAPE_COMPARISONS.include?([type, other.type])
      1
    else
      -1
    end
  end

  def shape_points
    SHAPE_POINT_MAPPING[type]
  end
end

class Game
  RESULT_POINTS_MAPPING = {
    'W' => 6,
    'D' => 3,
    'L' => 0
  }
  attr :player_shape, :opponent_shape

  def initialize(player_shape, opponent_shape)
    @player_shape = player_shape
    @opponent_shape = opponent_shape
  end

  def result
    if player_shape > opponent_shape
      'W'
    elsif player_shape == opponent_shape
      'D'
    else
      'L'
    end
  end

  def points
    RESULT_POINTS_MAPPING[result] + player_shape.shape_points
  end
end

require 'csv'

games = CSV.read('input.txt').map { |row| row[0].split(' ') }

OPPONENT_SHAPE_MAPPING = { 'A' => 'Rock', 'B' => 'Paper', 'C' => 'Scissors' }
PLAYER_SHAPE_MAPPING = { 'X' => 'Rock', 'Y' => 'Paper', 'Z' => 'Scissors' }

points =
  games.map do |actions|
    player_shape = Shape.new(PLAYER_SHAPE_MAPPING[actions[1]])
    opponent_shape = Shape.new(OPPONENT_SHAPE_MAPPING[actions[0]])

    game = Game.new(player_shape, opponent_shape)
    game.points
  end

puts "Part 1 result: #{points.sum}"

# Part 2

GOAL_MAPPING = { 'X' => 'L', 'Y' => 'D', 'Z' => 'W' }

points =
  games.map do |input|
    opponent_shape = Shape.new(OPPONENT_SHAPE_MAPPING[input[0]])
    goal = GOAL_MAPPING[input[1]]

    game_points = Game::RESULT_POINTS_MAPPING[goal]

    shape_points =
      case goal
      when 'D' then opponent_shape.shape_points
      when 'W'
        combination = Shape::STRONGER_SHAPE_COMPARISONS.find { |combi| combi[1] == opponent_shape.type }
        Shape.new(combination[0]).shape_points
      when 'L'
        combination = Shape::STRONGER_SHAPE_COMPARISONS.find { |combi| combi[0] == opponent_shape.type }
        Shape.new(combination[1]).shape_points
      end

    game_points + shape_points
  end

puts "Part 2 result: #{points.sum}"
