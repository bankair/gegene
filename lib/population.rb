require 'genome'

class Population
  DEFAULT_MUTATION_RATE = 0.01
  DEFAULT_KEEP_ALIVE_RATE = 0.1
  DEFAULT_EVOLVE_ITERATIONS = 1
  DEFAULT_FORCE_FITNESS_RECALCULATION = false
  
  attr_accessor :mutation_rate, :keep_alive_rate, :fitness_target, :karyotypes,
    :force_fitness_recalculation

  def evaluate
    @karyotypes.each do |karyotype|
      if (@force_fitness_recalculation || karyotype.fitness.nil?) then
        karyotype.fitness = @fitness_calculator.call(karyotype)
      end
    end
    @karyotypes.sort! { |x,y| y.fitness <=> x.fitness }
  end
  
  private :evaluate
  
  def initialize(size, genome, fitness_calculator)
    @force_fitness_recalculation = DEFAULT_FORCE_FITNESS_RECALCULATION
    @mutation_rate = DEFAULT_MUTATION_RATE
    @keep_alive_rate = DEFAULT_KEEP_ALIVE_RATE
    @genome = Genome.new(genome)
    @fitness_calculator = fitness_calculator
    @karyotypes = Array.new(size){ @genome.create_random_karyotype }
    evaluate
  end
  
  def set_mutation_rate(rate)
    @mutation_rate = rate
    self
  end
  
  def set_keep_alive_rate(rate)
    @keep_alive_rate = rate
    self
  end
  
  def set_fitness_target(target)
    @fitness_target = target
    self
  end
  
  def set_force_fitness_recalculation(target)
    @force_fitness_recalculation = target
    self
  end
  
  def size
    @karyotypes.size
  end

  def linear_random_select
    @karyotypes[rand @karyotypes.size]
  end
    
  def create_random_mutation
    linear_random_select.copy.mutate
  end

  private :linear_random_select, :create_random_mutation

  def random_select
    @karyotypes[
      @karyotypes.size - Integer(Math.sqrt(Math.sqrt(1 + rand(@karyotypes.size**4 - 1))))
    ]
  end
  
  def random_breed
    random_select + random_select
  end

private :random_select, :random_breed
  
  def evolve(iterations = DEFAULT_EVOLVE_ITERATIONS)
    i = 1
    while (i <= iterations) &&
      (@fitness_target.nil? || @fitness_target > @karyotypes[0].fitness) do
      evolve_impl
      i += 1
    end
    self
  end
  
  def evolve_impl
    new_population = []    
    
    # Keeping alive a specific amount of the best karyotypes
    keep_alive_count = Integer(@karyotypes.size * @keep_alive_rate)
    if keep_alive_count > 0 then
      @karyotypes[0, keep_alive_count].each {|karyotype| new_population.push(karyotype)}
    end
        
    mutation_count = Integer(@karyotypes.size * @mutation_rate)
    (0..mutation_count-1).each {
      new_population.push create_random_mutation
    }
    
    remaining = @karyotypes.size-mutation_count-keep_alive_count
    (0..remaining-1).each {
      child = random_breed
      new_population.push child      
    }
    @karyotypes = new_population
    evaluate
  end
  private :evolve_impl

end