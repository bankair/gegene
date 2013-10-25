require 'genome'
require 'gene'

describe Genome do
  
  it 'is constructed from an array of chromosome descriptions' do
    genome = Genome.new([
        {ival1: Gene.Integer(0, 255)}
      ])
  end
  
  it "cannot be constructed from something else" do
    lambda {gene = Genome.new("Oh, crap !")}.should raise_error
  end
  
  it "can create random Karyotypes" do
    genome = Genome.new([
        {ival_0_0: Gene.Integer(0, 255),
         ival_0_1: Gene.Integer(0, 255)},
        {ival_1_0: Gene.Integer(0, 255),
         ival_1_1: Gene.Integer(0, 255)}])
    karyotype = genome.create_random_karyotype()
    expect(karyotype.class).to eq Karyotype
  end
  
  it "is able to give the position (2 integers) of a named gene" do
    genome = Genome.new([
        {ival_0_0: Gene.Integer(0, 255),
         ival_0_1: Gene.Integer(0, 255)},
        {ival_1_0: Gene.Integer(0, 255),
         ival_1_1: Gene.Integer(0, 255)}])
      chromosome_pos, gene_pos = genome.get_gene_position(:ival_0_0)
      expect(chromosome_pos).to eq 0
      expect(gene_pos).to eq 0
      chromosome_pos, gene_pos = genome.get_gene_position(:ival_0_1)
      expect(chromosome_pos).to eq 0
      expect(gene_pos).to eq 1
      chromosome_pos, gene_pos = genome.get_gene_position(:ival_1_0)
      expect(chromosome_pos).to eq 1
      expect(gene_pos).to eq 0
      chromosome_pos, gene_pos = genome.get_gene_position(:ival_UNKNOWN)
      expect(chromosome_pos).to eq nil
      expect(gene_pos).to eq nil
    end
  
end