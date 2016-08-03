require 'gene'
require 'allele'
require 'forwardable'

# This class represent a chromosome, which contains several allele
# (gene's values) and is able to mutate, and to cross over.
class Chromosome
  extend Forwardable

  def_delegators :@alleles, :size, :[], :each_with_index, :map
  # Construct a chromosome from an array of alleles
  def initialize(alleles)
    unless alleles.is_a?(Array)
      puts alleles.inspect
      raise 'this constructor expect an array of alleles as input'
    end
    @alleles = alleles
  end

  # Copy the current chromosome and all its alleles
  def copy
    Chromosome.new(map(&:copy))
  end

  # Create a random chromosome from a description
  def self.create_random_from(description)
    new(description.map(&:create_random))
  end

  # Mutate a randomly selected allele of the current chromosome
  def mutate
    @alleles[rand size].mutate
  end

  # Aggregate all alleles values
  def aggregated_alleles
    map(&:value).join(';')
  end

  # Cross over two chromosomes to provide a new one
  def self.cross_over(chromo_a, chromo_b)
    chromo_a, chromo_b = randomize_chromosomes(chromo_a, chromo_b)
    size = chromo_a.size
    return chromo_a.copy if size < 2
    return new([chromo_a[0], chromo_b[1]].map!(&:copy)) if size == 2
    cross_over_impl(chromo_a, chromo_b, size)
  end

  def self.cross_over_impl(chromosome_a, chromosome_b, size)
    swap_index = rand(size - 1)
    new(chromosome_a.each_with_index.map do |from_a, index|
      (index <= swap_index ? from_a : chromosome_b[index]).copy
    end)
  end

  def self.randomize_chromosomes(*chromosomes)
    chromosomes.sort_by! { rand }
  end
end
