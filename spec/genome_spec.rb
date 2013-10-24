require 'genome'
require 'gene'

describe Genome do
  
  it 'is constructed from an array of chromosome descriptions' do
    gene = Genome.new([
        {ival1: Gene.Integer(0, 255)}
      ])
  end
  
  
end