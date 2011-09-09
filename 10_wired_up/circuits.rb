# Solution for Puzzlenode problem #10: All Wired Up
# 07/16/2011 Gregory Parkhurst
# Ruby 1.9.2p180

require './logic'

class Circuits
  include Logic

  attr_accessor :diagrams

  def initialize(filename, verbose = false)
    @filename = filename
    @verbose = verbose
    @iteration = 0
    build_diagrams
  end

  def build_diagrams
    width = 0

    diagrams = File.readlines(@filename).map do |l|
      line = l.chomp.rstrip
      width = line.size if line.size > width
      line
    end

    @diagrams = diagrams.map {|line| line = line.ljust(width) }
  end

  def solve
    until done?
      show_diagrams if @verbose

      perform :logic_for_wire

      transpose_diagrams
      perform :logic_for_gates
      transpose_diagrams

      perform :logic_for_bulbs
    end

    remove_whitespace 
    puts @diagrams
  end

  def perform(method)
    @diagrams.each do |line|
      self.send(method, line) 
    end
  end

  def done?
    @iteration += 1
    raise RuntimeError, "Solver seems to be hung" if @iteration > 20

    @diagrams.each do |line|
      return false if line =~ /[01]/
    end
    true
  end

  def transpose_diagrams
    matrix = @diagrams.map {|line| line.split ''}
    @diagrams = matrix.transpose.map {|row| row.join }
  end

  # The "on" and "off" signals should be the only things left.
  def remove_whitespace
    @diagrams.delete_if {|line| line !~ /\S/ }.map {|line| line.strip! }
  end
 
  def show_diagrams
    puts @diagrams
    puts "=====\n"
  end
end

if $PROGRAM_NAME == __FILE__
  raise RuntimeError,
    "Usage: #{$PROGRAM_NAME} input_filename [verbose]" unless ARGV[0]
  circuit = Circuits.new(ARGV[0], ARGV[1] && ARGV[1] == 'verbose')
  circuit.solve
end
