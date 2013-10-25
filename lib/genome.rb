require 'Karyotype'

class Genome
  
  def initialize(genome_description)
    raise "Genome description MUST be an Array" unless genome_description.is_a? Array
  end
  
end