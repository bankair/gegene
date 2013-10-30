require 'chromosome'
require 'digest/md5'
class Karyotype
  attr_accessor :chromosomes
  attr_accessor :fitness
  def initialize(genome, chromosomes_description)
    @genome = genome
    @chromosomes_description = chromosomes_description
  end
  private :initialize
  def copy
    karyotype = Karyotype.new(@genome, @chromosomes_description)
    karyotype.chromosomes = self.chromosomes.map{|chromosome| chromosome.copy}
    karyotype
  end
  def to_s
    @genome.gene_positions.keys.map{|gn| "#{gn}=>#{self[gn]}"}.join';'
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
  
  def +(other)
    child = copy
    other.chromosomes.each_with_index {
      |chromosome, index| child.chromosomes[index] = chromosome if rand(2) == 0
    }
    child
  end
  
  def to_md5()
    if (@hash_value.nil?) then
      @hash_value = @chromosomes.map{ |chromosome|
        chromosome.aggregated_alleles
      }.join(";")
      @hash_value = Digest::MD5.hexdigest(@hash_value)
    end
    @hash_value
  end
  
  def mutate
    @chromosomes[rand @chromosomes.size].mutate
    self
  end
end