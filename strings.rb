require 'minitest/spec'
require 'minitest/autorun'

=begin
0-------------|
              A------------|
1-------------|            |
                           X------------@
1-------------|            |
              N------------|
=end

#'0A1X1N'
def resolve(seq)
  seq = substitute(seq, '0', 'false')
  seq = substitute(seq, '1', 'true')
  seq = substitute(seq, 'A', '&&')
  seq = substitute(seq, 'X', '^')
  seq = substitute(seq, 'N', '!')
  seq = substitute(seq, 'true!', '!true')
end

def substitute(seq, sym, str)
  seq.gsub!(sym, str)
end

describe "substituting" do
  it "substitutes symbol with value" do
    substitute('0A1X1N', '0', 'false').must_equal 'falseA1X1N'
  end
  it "swaps strings" do
    substitute('false&&true^true!', 'true!', '!true').must_equal 'false&&true^!true'
  end
end

describe "evaling" do
  it "evals to value" do
    eval('false&&true^!true').must_equal false
  end
end

describe "the whole thing" do
  it "just works" do
    eval(resolve('0A1X1N')).must_equal false
  end
end


SYMBOLS = ['1', '0', 'A', 'O', 'X', 'N']

#take first symbol in line, do this:
str = ''
def parse(sym)
  str += sym if SYMBOLS.include? sym
  next
end
