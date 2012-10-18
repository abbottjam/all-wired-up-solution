require './parser.rb'
require './evaluator.rb'

def resolve(path)
  eval(transform(parse(path)))
end

require 'minitest/spec'
require 'minitest/autorun'

describe "test example circuit" do
  it "works" do
    resolve('files/example.txt').must_equal false
  end
end

