require 'genome'

class Population
  attr_accessor :mutation_rate, :keep_alive_rate
  def evaluate
    @karyotypes.each { |k| k.fitness = @fitness_calculator.call(k) }
    @karyotypes.sort! { |x,y| x.fitness <=> y.fitness }
  end
  def initialize(size, genome, fitness_calculator)
    @mutation_rate = 0.01
    @keep_alive_rate = 0.1
    @genome = genome
    @fitness_calculator = fitness_calculator
    @karyotypes = Array.new(size){ @genome.create_random_karyotype }
    self.evaluate
  end
  
  def set_mutation_rate(new_rate)
    @mutation_rate = new_rate
    self
  end
  
  def set_keep_alive_rate(new_rate)
    @keep_alive_rate = new_rate
    self
  end
  
  def size
    @karyotypes.size
  end

  def linear_random_select
    @karyotypes[rand @karyotypes.size]
  end
  
  def create_random_mutation
    linear_random_select.clone.mutate
  end

  def random_select
    @karyotypes[
      Integer(Math.sqrt(Math.sqrt(rand(@karyotypes.size**4))))
    ]
  end
  
  def random_breed
    random_select + random_select
  end
  
  def evolve(iterations = 1)
    (1..iterations).each { self.evolve_impl }
  end
  def evolve_impl
    new_population = nil
    # Keeping alive a specific amount of the best karyotypes
    keep_alive_count = Integer(@karyotypes.size * @keep_alive_rate)
    if keep_alive_count > 0 then
      new_population = @karyotypes[0, keep_alive_count]
    else
      new_population = []
    end
    mutation_count = Integer(@karyotypes.size * @mutation_rate)
    (0..mutation_count-1).each {
      new_population.push(self.create_random_mutation)
    }
    remaining = @karyotypes.size-mutation_count-keep_alive_count
    (0..remaining-1).each {
      new_population.push(random_breed)
    }
    @karyotypes = new_population
    self.evaluate
  end

end