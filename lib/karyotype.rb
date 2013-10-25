require 'chromosome'
class Karyotype
  attr_accessor :chromosomes
  def initialize(genome, chromosomes_description)
    @genome = genome
    @chromosomes_description = chromosomes_description
  end
  
  def copy
    karyotype = Karyotype.new(@genome, @chromosomes_description)
    karyotype.chromosomes = self.chromosomes.map{|chromosome| chromosome.copy}
    karyotype
  end
  
  def Karyotype.create_random_from(genome, chromosomes_description)
    karyotype = Karyotype.new(genome, chromosomes_description)
    karyotype.chromosomes = chromosomes_description.map {|description|
      Chromosome.create_random_from(description)
    }
    karyotype
  end
  
  def [](gene_name)
    return nil if @chromosomes.nil?
    chromosome_position, gene_position = @genome.get_gene_position(gene_name)
    return nil if chromosome_position.nil? || gene_position.nil?
    return @chromosomes[chromosome_position][gene_position].value
  end
  
end