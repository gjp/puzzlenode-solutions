class Canvas
  attr_reader :canvas_size, :canvas

  def initialize(size)
    @canvas_size = size
    @canvas = Array.new(size) { Array.new(size) {'.'} } 
  end

  def at(x,y)
    @canvas[x][y]
  end

  def draw_at(x,y)
    @canvas[x][y] = 'X'
  end

  def inspect
    @canvas.map {|row| row.join(' ') }.join("\n")
  end
end

class Turtle
  attr_reader :x, :y, :facing, :canvas

  def initialize(size)
    @center = size / 2
    @canvas = Canvas.new(size)
    reset
  end

  def turn_right(angle)
    @facing = (@facing + angle) % 360
  end

  def turn_left(angle)
    @facing = (@facing - angle) % 360
  end

  # Angled moves go an equal distance in BOTH X and Y.
  # That distant grinding sound is Pythagoras rolling in his grave. :p
  # A different method is required to handle other angles, but that would not match
  # the expected output for the puzzle.

  def move_forward(count)
    old_position = position

    if facing > 0 and facing < 180
      @x += count
    elsif facing > 180
      @x -= count
    end

    if facing > 90 and facing < 270
      @y += count
    elsif facing > 270 or facing < 90
      @y -= count
    end
    draw_line(old_position, position)
  end

  def move_backward(count)
    move_forward(-count)
  end

  def position
    [@x, @y]
  end

  def position=(x,y)
    @x, @y = x, y
  end

  def reset
    @x = @y = @center
    @facing = 0
    @position = [@x, @y]
  end

  # This will ONLY draw lines at 90 and 45 degree angles
  def draw_line(p1, p2)
    xs = arrange(p1.first, p2.first)
    ys = arrange(p1.last, p2.last)

    xs = xs * ys.size if ys.size > xs.size
    ys = ys * xs.size if xs.size > ys.size

    xs.zip(ys).each{|point| draw(point) }
  end

  def arrange(i,j)
    i <= j ? i.upto(j).to_a : i.downto(j).to_a
  end

  def draw(point)
    @canvas.draw_at(point.last, point.first)
  end
end

class TurtleController
  attr_reader :canvas_size, :turtle
  attr_accessor :commands

  Moves = {'LT' => 'turn_left',
           'RT' => 'turn_right',
           'FD' => 'move_forward',
           'BK' => 'move_backward'}
 
  def initialize(filename)
    @filename = filename
    parse_input
    @turtle = Turtle.new(@canvas_size)
  end

  def parse_input
    data = File.readlines(@filename).each {|l| l.chomp!}
    @canvas_size = data.shift.to_i
    data.shift
    @commands = data
  end

  def move_turtle(how, amount)
    turtle.send(Moves[how], amount.to_i)
  end

  def move_turtle_repeatedly(commands, many)
    many.times do
      commands.each {|command| move_turtle(*command.split) }
    end
  end

  def run_commands
    @commands.each do |command|
      if command.match( /^REPEAT (\d+) \[ ([^\]]+) \]/ )
        repeat, command_string = $~.captures
        commands = command_string.scan(/\w+ \d+/)
        move_turtle_repeatedly(commands, repeat.to_i)
      else
        move_turtle(*command.split)
      end
    end
  end

  def inspect
    @turtle.canvas.inspect
  end
end

if $PROGRAM_NAME == __FILE__
  raise RuntimeError, "Usage: #{$PROGRAM_NAME} input_filename" unless ARGV[0]
  t = TurtleController.new(ARGV[0])
  t.run_commands
  puts t.inspect
end
