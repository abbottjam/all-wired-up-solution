require 'minitest/spec'
require 'minitest/autorun'

=begin
0-------------|
              A------------|
1-------------|            |
                           X------------@
1-------------|            |
              N------------|

equals '((0A1)X(1N))'
=end

SUBSTITUTIONS = {
  '0' => 'false',
  '1' => 'true',
  'A' => '&&',
  'O' => '||',
  'X' => '^',
  'N' => '!',
  'true!' => '!true'
}

def transform(seq)
  SUBSTITUTIONS.each {|sym, value| seq.gsub!(sym, value)}
  seq
end

describe "transforming input sequence" do
  it "substitutes symbols with values" do
    transform('((0A1)X(1N))').must_equal '((false&&true)^(!true))'
  end
end

describe "evaling sequence" do
  it "evals expression to value" do
    eval('((false&&true)^(!true))').must_equal false
  end
end

describe "the whole thing" do
  it "just works" do
    eval(transform('((0A1)X(1N))')).must_equal false
  end
end



