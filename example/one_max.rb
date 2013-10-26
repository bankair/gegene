require 'gegene'

# Follow a genome description for the one max problem:
genome_description = [
    { v1: Gene.Integer(0,1) },
    { v2: Gene.Integer(0,1) },
    { v3: Gene.Integer(0,1) }
  ]

# Here is the fitness function of the one max problem:
def fitness(karyotype)
  karyotype[:v1] + karyotype[:v2] + karyotype[:v3]
end

# We create a population of six individuals with the previous desc & func:
population = Population.new(6, genome_description, method(:fitness))

# As we known that the best solution for the one max problem, we set a
# fitness target of 3 (1+1+1).
population.fitness_target = 3

# As the population is quite small, we add a little more funk to our
# evolution process by setting a 30% mutation rate
population.mutation_rate = 0.3

# Let's go for some darwinist fun !
population.evolve(10)

# population.karyotypes is sorted by fitness score, so we can assume that
# the first element is the fittest
best_karyotype = population.karyotypes[0]

puts "Best karyotype scored #{best_karyotype.fitness}:"
[:v1, :v2, :v3].each {|x| puts "    #{x.to_s}:#{best_karyotype[x]}" }
