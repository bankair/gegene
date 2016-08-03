# Specific value for a specific gene
class Allele
  attr_accessor :value
  def initialize(gene, value)
    @gene = gene
    @value = value
  end

  def mutate
    @value = @gene.mutate(@value)
  end

  def copy
    # /!\ if @value is a ref, its underlying object won't be copied
    Allele.new(@gene, @value)
  end
end
