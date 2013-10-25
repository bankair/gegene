require 'gene'
require 'allele'
class Chromosome
  
  def initialize(alleles)
    @alleles = alleles
  end
  
  def Chromosome.create_random_from(description)
    Chromosome.new(description.map{|gene| gene.create_random() })
  end
  
end