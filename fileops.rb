require 'minitest/spec'
require 'minitest/autorun'

def parse_1(file_path)
  IO.read(file_path).split("\n").select! {|line| !line.empty?}
end

def parse_2(file_path)
  IO.read(file_path).split("\n")
end

def parse_3(file_path)
  arr = IO.read(file_path).split("\n")
  return arr unless arr.include? ""
  arr.select! {|line| !line.empty?}
end

=begin
here-doc of the desired string, compare it to various inputs (with / without leading
empty lines) and methods, and find the method that parses all possible inputs correctly.

Some readlines BS:
http://www.ruby-forum.com/topic/132198
http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/158212

=end
describe "parses the input to a standard form regardless of the number of blank lines" do
  before do
    @arr = [
      "0-------------|",
      "              A------------|",
      "1-------------|            |",
      "                           X------------@",
      "1-------------|            |",
      "              N------------|"
    ]
  end
  it "parses uniformly" do
    parse_1('files/example.txt').must_equal @arr
    parse_2('files/example-1.txt').must_equal @arr
    parse_3('files/example.txt').must_equal @arr
    parse_3('files/example-1.txt').must_equal @arr
  end
end


