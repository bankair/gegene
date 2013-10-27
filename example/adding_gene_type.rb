require 'gegene'

class PalindromeGene < Gene      
    def initialize(size)
      @size = size
    end

    # Will raise an error in Gene class if not overloaded here
    def random_allele_value
      prefix = Array.new(@size/2){ rand(97..122).chr}.join("")
      prefix + (@size%2 == 0 ? "" : rand(97..122).chr) +prefix.reverse()
    end

    # Will raise an error in Gene class if not overloaded here
    def mutate(previous_value)
      self.random_allele_value
    end
end

# The following code is not mandatory
# use it if you'd rather have Gene.Palyndrome(9) instead of a ctor call
#class Gene
#  Gene.Palyndrome(size) PalyndromeGene.new(size) end
#end

genome_description = [{palyndrome:PalindromeGene.new(9)}]

def fitness(karyotype)
  karyotype[:palyndrome].split(//).select{|c| c =~ /[aeiou]/}.size
end

population = Population.new(25, genome_description, method(:fitness))
population.evolve(10)
puts population.karyotypes[0][:palyndrome]