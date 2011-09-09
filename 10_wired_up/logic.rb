# This module exists only to serve the circuit solver for
# Puzzlenode problem #10: All Wired Up.
#
# It implements regular expressions which successively reduce a circuit diagram
# to its output as they are iterated.
#
# 07/18/2011 (refactored) Gregory Parkhurst
# ruby 1.9.2p180

module Logic
  # Shift ones and zeroes to the right until they encounter a gate
  # Output is padded with spaces to preserve line length
  Wire = %r/ ([01]) -+\|/x

  def logic_for_wire(line)
    line.sub!(Wire) do
      match, input = *$~
      input.rjust(match.size)
    end
  end

  # Reduce gates and their input(s) to their output
  BinaryOps = {'A' => '&', 'X' => '^', 'O' => '|'}

  BinaryGate = %r/ ([01]) (\|*) ([AXO]) (\|*) ([01]) /x
  NotGate = %r/ ([01]) (\|*) (N) /x
  
  def logic_for_gates(line)
    line.gsub!(BinaryGate) do 
      input1, wire1, operation, wire2, input2 = *$~.captures

      # Ask zero and one to operate on themselves, e.g. 0.send('&', 1)
      output = input1.to_i.send(BinaryOps[operation], input2.to_i)

      pad(wire1) + output.to_s + pad(wire2)
    end

    line.gsub!(NotGate) do 
      input, wire1 = *$~.captures
      pad(wire1) + (input == '1' ? '0' : '1')
    end

    line
  end

  # Replace a digit connected directly the bulb with "on" or "off"
  Bulb = %r/ ([01]) -+@ /x

  def logic_for_bulbs(line)
    line.sub!(Bulb) do
      match, input = *$~
      (input == '1' ? 'on' : 'off').rjust(match.size)
    end
  end

  # As wires are removed, they are replaced with whitespace
  def pad(wire)
    wire ? ' ' * (wire.size + 1) : ' '
  end
end
