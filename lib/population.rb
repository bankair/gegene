require 'genome'
# Stand for a whole population used for an evolution experiment
class Population
  DEFAULT_MUTATION_RATE = 0.01
  DEFAULT_KEEP_ALIVE_RATE = 0.1
  DEFAULT_EVOLVE_ITERATIONS = 1
  DEFAULT_FORCE_FITNESS_RECALCULATION = false

  attr_accessor :fitness_target, :karyotypes, :force_fitness_recalculation
  attr_reader :mutation_rate, :keep_alive_rate

  # mutation rate setter function
  # Accept values in the range [0,1]
  def mutation_rate=(value)
    @mutation_rate = validate!(:mutation_rate, value)
  end

  # keep alive rate setter function
  # Accept values in the range [0,1]
  def keep_alive_rate=(value)
    @keep_alive_rate = validate!(:keep_alive_rate, value)
  end

  def initialize(size, genome, fitness_calculator)
    raise 'size must be strictly positive.' if size < 1
    @fitness_hash = {}
    @force_fitness_recalculation = DEFAULT_FORCE_FITNESS_RECALCULATION
    @mutation_rate = DEFAULT_MUTATION_RATE
    @keep_alive_rate = DEFAULT_KEEP_ALIVE_RATE
    @genome = Genome.new(genome)
    @fitness_calculator = fitness_calculator
    @karyotypes = Array.new(size) { @genome.create_random_karyotype }
    evaluate
  end

  %i(mutation_rate keep_alive_rate
     fitness_target force_fitness_recalculation).each do |sym|
    define_method("set_#{sym}") { |value| tap { |o| o.send("#{sym}=", value) } }
  end

  def size
    @karyotypes.size
  end

  # This function make ou population evolving by:
  # * Selecting and breeding the fittest karyotypes
  # * Running the fitness evaluation on all the newly created karyotyopes
  # The selection process include three subprocesses:
  # * Selecting the fittest individuals to keep alive
  # * Mutating randomly (linear) selected individuals
  # * Breeding randomly (fitness weighted) selected individuals
  def evolve(iterations = DEFAULT_EVOLVE_ITERATIONS)
    i = 1
    while (i <= iterations) &&
          (@fitness_target.nil? || @fitness_target > @karyotypes[0].fitness)
      evolve_impl
      i += 1
    end
    self
  end

  private

  NO_FITNESS = :no_fitness

  # Run the fitness function for all karyotypes, and sort it by fitness
  def evaluate
    if @force_fitness_recalculation
      @karyotypes.each { |karyotype| update!(karyotype, fitness(karyotype)) }
    else
      @karyotypes.each do |karyotype|
        update!(karyotype, cached_fitness(karyotype)) if karyotype.fitness.nil?
      end
    end
    @karyotypes.sort_by(&:fitness)
  end

  def update!(karyotype, fitness)
    karyotype.fitness = fitness
    @fitness_hash[karyotype.to_md5] = karyotype.fitness
  end

  def fitness(karyotype)
    @fitness_calculator.call(karyotype)
  end

  def cached_fitness(karyotype)
    @fitness_hash.fetch(karyotype.to_md5) { fitness karyotype }
  end

  def evolve_impl
    # Keeping alive a specific amount of the best karyotypes
    keep_alive_count = Integer(@karyotypes.size * @keep_alive_rate)
    mutation_count = Integer(@karyotypes.size * @mutation_rate)
    @karyotypes = build_new_karyotypes(keep_alive_count, mutation_count)
    evaluate
  end

  def build_new_karyotypes(keep_alive_count, mutation_count)
    remaining = @karyotypes.size - mutation_count - keep_alive_count
    @karyotypes[0, keep_alive_count]
      .concat(Array.new(mutation_count) { create_random_mutation })
      .concat(Array.new(remaining) { random_breed })
  end

  def linear_random_select
    @karyotypes[rand @karyotypes.size]
  end

  def create_random_mutation
    linear_random_select.copy.mutate
  end

  def fitness_weighted_random_select
    @karyotypes[
      @karyotypes.size -
      Integer(Math.sqrt(Math.sqrt(1 + rand(@karyotypes.size**4 - 1))))
    ]
  end

  def random_breed
    fitness_weighted_random_select + fitness_weighted_random_select
  end

  def validate!(label, value)
    raise "#{label} value must be included in [0,1]" unless value.between?(0, 1)
    value
  end
end
