require './parser.rb'
require './evaluator.rb'

require 'minitest/spec'
require 'minitest/autorun'

def resolve(path)
  expressions = Circuit.new(path).parse_all
  values = expressions.map {|val| eval(transform(val))}
  values.map {|val| val.eql?(true) ? 'on' : 'off'}
end

describe "simple circuits evaluate to correct output" do
  it "works" do
    resolve('files/simple_circuits.txt').must_equal ['on', 'off', 'on']
  end
end

describe "complex circuits evaluate to correct output" do
  it "works, too" do
    resolve('files/complex_circuits.txt').must_equal ['on', 'off', 'on']
  end
end

#Circuit.new('files/simple_circuits.txt').parse_all
