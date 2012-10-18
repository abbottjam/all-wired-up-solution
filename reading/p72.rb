require 'strscan'
str = "Watch how I soar!"

ss = StringScanner.new(str)
loop do
  word = ss.scan(/\w+/)     # Grab a word at a time
  break if word.nil?
  puts word
  sep = ss.scan(/\W+/)      # Grab next non-word piece
  break if sep.nil?
end

