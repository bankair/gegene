require 'Karyotype'

# This class stands for the genome. It is a description of all
# the gene describing a specific population.
class Genome
  
  DEFAULT_CROSS_OVER_RATE = 0.01
  
  def initialize(genome_description)
    raise "Genome description MUST be an Array" unless genome_description.is_a? Array
    @chromosomes_description = []
    @gene_positions = {}
    genome_description.each_with_index do |chomosome_hash, chromosome_position|
      gene_array = []
      chomosome_hash.keys.each_with_index do |gene_name, gene_position|
        @gene_positions[gene_name] = [chromosome_position, gene_position]
        gene_array << chomosome_hash[gene_name]
      end
      @chromosomes_description << gene_array
    end
    @cross_over_rate = DEFAULT_CROSS_OVER_RATE
  end
  attr_accessor :gene_positions
  attr_reader :cross_over_rate
  def cross_over_rate=(rate)
    raise "cross_over_rate must be included in [0,1]" unless rate.between?(0,1)
    @cross_over_rate = rate
  end
  
  def get_gene_position(gene_name)
    @gene_positions[gene_name]
  end
  
  def create_random_karyotype
    Karyotype.create_random_from(self, @chromosomes_description)
  end
  
end