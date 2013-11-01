require 'chromosome'
require 'digest/md5'
# This class represent a karyotype, which could be seen as a set of
# chromosomes representing a specific individual of a population
class Karyotype
  attr_accessor :chromosomes
  attr_accessor :fitness
  
  def initialize(genome, chromosomes_description)
    @genome = genome
    @chromosomes_description = chromosomes_description
  end
  private :initialize
  
  # Copy self and all its chromosomes to a new karyotype
  def copy
    karyotype = Karyotype.new(@genome, @chromosomes_description)
    karyotype.chromosomes = self.chromosomes.map{|chromosome| chromosome.copy}
    karyotype
  end
  
  def to_s
    @genome.gene_positions.keys.map{|gn| "#{gn}=>#{self[gn]}"}.join';'
  end
  
  # Create a random karyotype from a specific genome an its associated
  # chromosomes description
  def Karyotype.create_random_from(genome, chromosomes_description)
    karyotype = Karyotype.new(genome, chromosomes_description)
    karyotype.chromosomes = chromosomes_description.map {|description|
      Chromosome.create_random_from(description)
    }
    karyotype
  end
  
  # Return the allele value of a specific named gene
  # We strongly recommand using symbols as gene name
  def [](gene_name)
    return nil if @chromosomes.nil?
    chromosome_position, gene_position =
      @genome.get_gene_position(gene_name)
    return nil if chromosome_position.nil? || gene_position.nil?
    return @chromosomes[chromosome_position][gene_position].value
  end
  
  # Breeding function
  # Create a new karyotype based on self and an other
  def +(other)
    child = Karyotype.new(@genome, @chromosomes_description)
    child.chromosomes = []
    other.chromosomes.each_with_index { |chromosome, index|
      child_chromosome = nil
      # Randomly copy chromosomes from dad or mom to child
      if (rand(100) / 100.0) < @genome.cross_over_rate then
        # Crossing over required
        child_chromosome =
          Chromosome.cross_over(chromosome, chromosomes[index])
      else
        # Standard breeding via random selection
        child_chromosome = (rand(2)==0?chromosome : chromosomes[index]).copy
      end
      child.chromosomes.push(child_chromosome)
    }
    child
  end
  
  # Aggregate all the allele into a md5 hash value
  def to_md5()
    if (@hash_value.nil?) then
      @hash_value = @chromosomes.map{ |chromosome|
        chromosome.aggregated_alleles
      }.join(";")
      @hash_value = Digest::MD5.hexdigest(@hash_value)
    end
    @hash_value
  end
  
  # Randomly mutate an allele of a randomly selected chromosome
  def mutate
    @chromosomes[rand @chromosomes.size].mutate
    self
  end
end