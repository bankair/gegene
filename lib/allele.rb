class Allele
  attr_accessor :value
  def initialize(gene, value)
    @gene = gene
    @value = value
  end
  
  def mutate
    @value = @gene.mutate(@value)
  end
end