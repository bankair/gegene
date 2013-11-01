require 'karyotype'
require 'genome'

describe Karyotype do
  
  before(:each) do
    @genome = double(Genome)
    @genome.stub(:get_gene_position){[0, 0]}
  end
  
  it "can be created from a genome" do
    karyotype = Karyotype.create_random_from(@genome, [[Gene.Integer(0,12)]])
    expect(karyotype.class).to eq Karyotype
    expect(karyotype[:fake_gene_name].between?(0,12))
  end
  
  it "can be copied" do
    karyotype = Karyotype.create_random_from(@genome, [[Gene.Integer(0,12)]])
    karyotype_copy = karyotype.copy
    expect(karyotype[:fake_gene_name]).to eq karyotype_copy[:another_fake_name]
  end
  
  it "can search its alleles by the associated gene's name" do
    karyotype = Karyotype.create_random_from(@genome,
      [[Gene.Integer(0,5), Gene.Integer(5,9)]])
    @genome.stub(:get_gene_position){ |e| {a:[0,0], b:[0,1]}[e] }
    expect(karyotype[:a].between?(0,5))
    expect(karyotype[:b].between?(5,9))
  end
  
  it "can mutate" do
    karyotype = Karyotype.create_random_from(@genome, [[Gene.Integer(0,5)]])
    @genome.stub(:get_gene_position){[0,0]}
    previous_value = karyotype[:fake_gene_name]
    karyotype.mutate
    expect(previous_value != karyotype[:fake_gene_name])
  end
  
  it "can concatenate its alleles and provide a md5 hash value out of it" do
    karyotype = Karyotype.create_random_from(@genome, [[Gene.Integer(0,5)]])
    expect((0..5).to_a.map{|x|Digest::MD5.hexdigest(x.to_s)}).to include karyotype.to_md5
  end
end