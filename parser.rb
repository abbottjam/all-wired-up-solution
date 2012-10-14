require 'minitest/spec'
require 'minitest/autorun'

SYMBOLS = /[10AOXN]/

def parse(file_path)
  File.open(file_path) do |f|
   res = ''
   while line = f.gets
    f.readlines.each do |str|
      match = str.match SYMBOLS
      res += match[0]
    end
  end
  res
end
end

describe "parsing" do
  it "represents the circuit as string" do
    parse('files/example.txt').must_equal '0A1X1N'
  end
end
