=begin
0-------------|
              A------------|
1-------------|            |
                           X------------@
1-------------|            |
              N------------|

equals '((0A1)X(N1))'
=end

SUBSTITUTIONS = {
  '0' => 'false',
  '1' => 'true',
  'A' => '&&',
  'O' => '||',
  'X' => '^',
  'N' => '!'
}

def transform(seq)
  SUBSTITUTIONS.each { |sym, value| seq.gsub!(sym, value) }
  seq
end
