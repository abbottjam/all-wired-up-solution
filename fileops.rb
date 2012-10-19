require 'minitest/spec'
require 'minitest/autorun'

def open_with_file(file_path)
  File.open(file_path) do |f|
    puts f.readlines
    return f
  end
end

def open_with_stream(file_path)
  str = ARGF.read 1
  puts str
  str
end

def convert_string_to_board(file_path)
  lines = ''
  File.open(file_path) do |f|
    f.readlines.each {|line|  lines << line}
    lines = lines.split("\n")
    m = lines.map { |line| line.split(//) }
    #puts m
    m
  end
end

def write_board_to_file(file_path)
  lines = ''
  File.open('files/board_output.txt', 'w') do |dest|
    File.open(file_path) do |source|
      source.readlines.each {|line|  lines << line}

      lines = lines.split("\n")
      #lines = lines.map { |line| line.split(//) } UPS!

      dest.write lines
    end
  end
end


describe "opening with the File class" do
  it "opens as a File class" do
    #open_with_file('files/example.txt').class.must_equal File
    #f = open_with_file('files/example.txt')
    #puts f.class
  end
end

#call like this: ruby fileops.rb 'files/example.txt'
describe "opening with ARGF" do
  it "opens as a String class" do
    #open_with_stream('files/example.txt').class.must_equal String
    #f = open_with_stream('files/example.txt')
    #puts f.class
  end
end

#convert_string_to_board('files/example.txt')
write_board_to_file('files/example.txt')


=begin
The output here looks fucked up. Print it to a file and compare with ditto from Josh's.
Finally, ask on StackOverflow how to move around (up / down, left / right) in a text
file with ACII chars (maze game example).
=end



