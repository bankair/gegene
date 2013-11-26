require 'gene'
require 'allele'

# This class represent a chromosome, which contains several allele (gene's values)
# and is able to mutate, and to cross over.
class Chromosome
  
  # Construct a chromosome from an array of alleles
  def initialize(alleles)
    raise "this constructor expect an array of alleles as input" unless
      alleles.is_a?(Array)
    @alleles = alleles
  end
  
  # Copy the current chromosome and all its alleles
  def copy
    Chromosome.new(@alleles.map{|allele| allele.copy })
  end
  
  # Create a random chromosome from a description
  def Chromosome.create_random_from(description)
    Chromosome.new(description.map{|gene| gene.create_random() })
  end
  
  # Returns the allele at a specific position
  def [](gene_position)
    @alleles[gene_position]
  end
  
  # Number of underlying alleles
  def size
    @alleles.size
  end
  
  # Mutate a randomly selected allele of the current chromosome
  def mutate
    @alleles[rand @alleles.size].mutate()
  end
  
  # Aggregate all alleles values
  def aggregated_alleles()
    @alleles.map {|a| a.value}.join(';')
  end
  
  # Cross over two chromosomes to provide a new one
  def Chromosome.cross_over(chromosome_a, chromosome_b)
    if rand(2) == 0 then
      chromosome_a, chromosome_b = chromosome_b, chromosome_a
    end
    size = chromosome_a.size
    if size < 2 then
      return chromosome_a.copy
    elsif size == 2 then
      return Chromosome.new([chromosome_a[0],chromosome_b[1]])
    else
      swap_index = rand(size-1)
      index = 0
      new_alleles = []
      while (index < size) do
        new_alleles.push(
          (index <= swap_index ? chromosome_a : chromosome_b)[index].copy)
        index += 1
      end
      return Chromosome.new(new_alleles)
    end
  end
  
end