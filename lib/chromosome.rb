require 'gene'
require 'allele'
class Chromosome
  
  def initialize(alleles)
    @alleles = alleles
  end
  
  def copy
    Chromosome.new(@alleles.map{|allele| allele.copy })
  end
  
  def Chromosome.create_random_from(description)
    Chromosome.new(description.map{|gene| gene.create_random() })
  end
  
  def [](gene_position)
    @alleles[gene_position]
  end
  
  def mutate
    @alleles[rand @alleles.size].mutate
  end
  
end