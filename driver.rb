require './parser.rb'
require './evaluator.rb'

def do_stuff
  str = parse('files/example.txt')
  eval(resolve(str))
end

require 'minitest/spec'
require 'minitest/autorun'

describe "test" do
  it "must work" do
    do_stuff.must_equal false
  end
end
