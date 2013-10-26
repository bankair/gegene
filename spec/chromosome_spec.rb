require 'chromosome'

describe Chromosome do
  
  it "can be created from an allele array" do
    fake_allele_array = (1..5).to_a.map {double(Allele)}
    chromosome = Chromosome.new(fake_allele_array)
    expect(!chromosome.nil?)
    expect(chromosome.class).to eq Chromosome
  end
  
  it "allow to retrieve an allele value by its index" do
    chromosome = Chromosome.new(
      [ Allele.new(double(Gene), false),
        Allele.new(double(Gene), true)])
    expect(!chromosome[0])
    expect(chromosome[1])
  end
  
  it "can copy itself" do
    chromosome = Chromosome.new(
      [ Allele.new(double(Gene), false),
        Allele.new(double(Gene), true)])
    chromosome_copy = chromosome.copy
    expect(!chromosome_copy[0])
    expect(chromosome_copy[1])
  end
  
  it "can be created from a gene description array" do
    description = [
      Gene.Integer(0,3),
      Gene.Integer(4,7),
      Gene.Integer(8,12)
    ]
    chromosome = Chromosome.create_random_from(description)
    expect(chromosome[0].value.between?(0,3))
    expect(chromosome[1].value.between?(4,7))
    expect(chromosome[2].value.between?(8,12))
  end
  
  it "can mutate" do
    chromosome = Chromosome.create_random_from([Gene.Integer(0, 3)])
    previous_value = chromosome[0]
    chromosome.mutate
    expect(previous_value != chromosome[0])
  end
    
  
end