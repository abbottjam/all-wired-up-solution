require_relative "lib/evaluator.rb"
require_relative "lib/parser.rb"

#require File.expand_path('lib/evaluator.rb', File.dirname(__FILE__))
#require File.expand_path('lib/parser.rb', File.dirname(__FILE__))

def resolve(path)
  expressions = Circuit.new(path).parse_all
  values = expressions.map {|val| eval(transform(val))}
  values.map {|val| val.eql?(true) ? 'on' : 'off'}
end

def print
  solved = resolve('./files/input/complex_circuits.txt')
  File.open('./files/output/complex_output.txt', "w") do |io|
    solved.each {|str| io.write str + "\n"}
  end
end

print
