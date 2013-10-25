require 'Karyotype'

class Genome
  
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
  end
  
  def get_gene_position(gene_name)
    @gene_positions[gene_name]
  end
  
  def create_random_karyotype
    Karyotype.create_random_from(self, @chromosomes_description)
  end
  
end