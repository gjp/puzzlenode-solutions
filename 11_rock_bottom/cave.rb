# Solution to puzzlenode problem #11: Rock Bottom
# 07/15/2011 Gregory Parkhurst
# Ruby 1.9.2p180

class Cave
  Air, Water = ' ', '~'

  attr_reader :flow_count, :map

  def initialize(filename)
    @filename = filename
    @flow_x, @flow_y = 0, 1
    parse_file
  end

  def parse_file
    data = File.readlines(@filename).each {|l| l.chomp!}
    # The first water cell is already on the map
    @flow_count = data.shift.to_i - 1
    data.shift
    # Dump the input file into a 2d array and work with it directly
    @map = data.map {|line| line.split ''}
  end

  def try_flowing_down
    @flow_y += 1 if @map[@flow_y + 1][@flow_x] == Air
  end

  def try_flowing_right
    @flow_x += 1 if @map[@flow_y][@flow_x + 1] == Air
  end

  def flow_up
    @flow_y -= 1
    @flow_x = @map[@flow_y].index(Air)
  end

  def fill
    @map[@flow_y][@flow_x] = Water
  end

  def flow
    @flow_count.times do
      try_flowing_down or try_flowing_right or flow_up and fill
    end
  end

  WaterHeight = %r/(?<water>#{Water}+)(?<air>#{Air}*)\#+$/

  def measure
    transposed.map do |column|
      # Count the number of water cells with a regexp.
      # Return the water symbol instead if flow was halted in midair.
      if m = column.match(WaterHeight)
        m['air'].size > 0 ? Water : m['water'].size
      else
        0
      end
    end.join ' '
  end

  def transposed
    # Flip the map array sideways and convert it to strings.
    @map.transpose.map{|row| row.join}
  end

  def inspect
    @map.map {|row| row.join + "\n"}
  end
end

if $PROGRAM_NAME == __FILE__
  raise RuntimeError,
    "Usage: #{$PROGRAM_NAME} input_filename [verbose]" unless ARGV[0]
  c = Cave.new(ARGV[0])
  verbose = ARGV[1] && ARGV[1] == 'verbose'
  puts c.inspect if verbose
  c.flow
  puts c.inspect if verbose
  puts c.measure
end
