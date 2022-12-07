# Part 1
console = File.open('input.txt').read.split("\n")

class PuzzleFile
  attr_accessor :name, :size
  def initialize(name, size)
    @name = name
    @size = size
  end
end

class PuzzleDirectory
  attr_accessor :name, :parent, :directories, :files

  def initialize(parent, name, list)
    @parent = parent
    @name = name
    @directories = []
    @files = []
  end

  def set_list(list)
    list.each do |item|
      case item
      when PuzzleFile then files << item
      when PuzzleDirectory then directories << item
      end
    end
  end

  def size
    files.sum(&:size) + directories.sum(&:size)
  end

  def subdirectories_with_sizes
    directories.map { |d| { d.name => d.size } } +
      directories.map { |dir| dir.subdirectories_with_sizes }.flatten
  end

  def in(dir)
    directories.find { |d| d.name == dir }
  end

  def out
    parent
  end

  def root
    a = self
    a = a.parent until a.name == '/'
    return a
  end
end

def next_command_and_position(console, starting_line)
  next_command = console[starting_line..].find { |x| x[0] == '$' }
  return *[nil, nil] unless next_command
  line = console[starting_line..].index(next_command) + starting_line
  return *[next_command, line]
end

def list(console, line, directory)
  from = line + 1
  _, next_command_line = next_command_and_position(console, from)
  to = next_command_line ? next_command_line - 1 : console.size - 1

  # build up local directory structure
  ls =
    console[from..to].map do |item|
      a, b = item.split(' ')
      a == 'dir' ?  PuzzleDirectory.new(directory, b, []) : PuzzleFile.new(b, a.to_i)
    end
end

file_system = PuzzleDirectory.new(nil, '/', [])
current_directory = file_system # pointer
line = 1

while !next_command_and_position(console, line).compact.empty? do
  next_command, line = next_command_and_position(console, line)
  parsed_command = next_command.split(' ')

  case parsed_command[1]
  when 'cd'
    current_directory =
      case parsed_command[2]
      when '/'
        current_directory.root
      when '..'
        current_directory.out
      else
        current_directory.in(parsed_command[2])
      end
  else # ls
    current_directory.set_list(list(console, line, current_directory))
  end

  line += 1
end

total_of_directories_max_100000 =
  file_system.
    subdirectories_with_sizes.
    map(&:values).map(&:first).
    select { |s| s <= 100000 }.
    sum

puts "Part 1 Result: #{total_of_directories_max_100000}"

# Part 2

MAX_DISK_SPACE = 70_000_000
TOTAL_REQUIRED_DISK_SPACE = 30_000_000
current_free_space = MAX_DISK_SPACE - file_system.size
min_space_to_free = TOTAL_REQUIRED_DISK_SPACE - current_free_space

size_of_directory_to_delete =
  file_system.
    subdirectories_with_sizes.
    map(&:values).map(&:first).
    sort.
    find { |s| s >= min_space_to_free }

puts "Part 2 Result: #{size_of_directory_to_delete}"
