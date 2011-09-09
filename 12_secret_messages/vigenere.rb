class Vigenere
  def initialize(filename, key)
    @cipher_text = parse_input(filename)
    @key = key.split ''
    @alphabet = ('A'..'Z').reduce(:+)
  end

  def decipher
    @cipher_text.split('').map do |char|
      if @alphabet.include? char
        char = @alphabet[char.ord - @key.first.ord]
        @key.rotate!
      end
      char
    end.join
  end

  # Strip out the Caesar-ciphered key and return the cipher text
  def parse_input(filename)
    data = File.readlines(filename)
    data.shift(2)
    data.join
  end
end

if __FILE__ == $PROGRAM_NAME
  # Deciphering the key requires either eyeballs or a dictionary, so the key is
  # assumed to have been deciphered already and is passed in as the 2nd argument.
  d = Vigenere.new(ARGV[0], ARGV[1])
  puts d.decipher
end
