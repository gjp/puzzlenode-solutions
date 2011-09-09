def caesar(text, offset)
  alpha2=('A'..'Z').to_a * 2 # A..ZA..Z
  text.tr('A-Z', alpha2[offset..offset+26].join)
end

text = ARGV[0]

(0..25).each do |shift|
  plain = caesar(text, shift)
  puts plain unless plain =~ /[^AEIOU]{4}/
end
