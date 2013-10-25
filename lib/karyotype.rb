require 'chromosome'
class Karyotype
  def initialize(genome, chromosome_description_array)
    @genome = genome
    @chromosomes = chromosome_description_array.map {|chromosome_description|
      Chromosome.new(chromosome_description)
    }
  end
  
  def [](gene_name)
    chromosome_position, gene_position = @genome.get_gene_position(gene_name)
    return nil if chromosome_position.nil? || gene_position.nil?
    return @chromosomes[chromosome_position][gene_position].value
  end
end