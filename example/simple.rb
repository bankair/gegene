require 'gegene'
FITNESS_TARGET = 1 / 0.001
population = Population.new(
    50,
    [{a:Gene.Integer(0, 5)},{b:Gene.Integer(-5,5)}],
    lambda {|k| 1 / (0.001 + (12-(k[:a]**2+k[:b])).abs) }
  )
population.set_mutation_rate(0.5).set_fitness_target(FITNESS_TARGET).evolve(50)
bk = population.karyotypes[0]
warn "a:#{bk[:a]} b:#{bk[:b]} => a*a + b = #{bk[:a]**2+bk[:b]}"
