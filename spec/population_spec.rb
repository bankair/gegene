require 'population'
require 'karyotype'
require 'genome'
class Counter
  attr_accessor :value
  def initialize
    @value = 0
  end
  def increment(k)
    @value += 1
  end
end

describe Population do

  before(:each) do
    @counter = Counter.new
    @genome = [{dummy_value:Gene.Integer(0,1)}]
    # @karyotype = double(Karyotype)
    # @karyotype.stub(:breed){@karyotype}
    # @karyotype.stub(:mutate){@karyotype}
    # @karyotype.stub(:clone){@karyotype}
    # @karyotype.stub(:+){@karyotype}
    # @karyotype.stub(:create_random_from){double(Chromosome)}
    # @karyotype.stub(:fitness=){nil}
    # @karyotype.stub(:fitness){0}
    # @genome = double(Genome)    
  end

  it "can be created at a specific size" do
    population = Population.new(200, @genome, @counter.method(:increment))
    expect(population.size).to eq 200
    expect(@counter.value).to eq 2
  end
  
  it "can evolve" do
    population = Population.new(200, @genome, @counter.method(:increment))
    population.force_fitness_recalculation = true
    expect(@counter.value).to eq 2
    population.evolve()
    expect(@counter.value).to eq 202
  end

  it "can evolve several times" do
    population = Population.new(200, @genome, @counter.method(:increment))
    expect(@counter.value).to eq 2
    population.force_fitness_recalculation = true
    population.evolve(2)
    expect(@counter.value).to eq 402
  end
  
  it "has a mutation rate which default value is 1%" do
    population = Population.new(200, @genome, @counter.method(:increment))
    expect(population.mutation_rate).to eq 0.01
    population.mutation_rate = 0.02
    expect(population.mutation_rate).to eq 0.02
    set_function_return = population.set_mutation_rate(0.03)
    expect(set_function_return).to eq population
    expect(population.mutation_rate).to eq 0.03
  end
  
  it "has a keep alive rate which default value is 10%" do
    population = Population.new(200, @genome, @counter.method(:increment))
    expect(population.keep_alive_rate).to eq 0.1
    population.keep_alive_rate = 0.2
    expect(population.keep_alive_rate).to eq 0.2
    set_function_return = population.set_keep_alive_rate(0.3)
    expect(set_function_return).to eq population
    expect(population.keep_alive_rate).to eq 0.3
  end
  
  it "has a fitness target which default value is nil" do
    population = Population.new(200, @genome, @counter.method(:increment))
    population.force_fitness_recalculation = true
    expect(population.fitness_target.nil?).to be_true
    expect(@counter.value).to eq 2
    population.evolve()
    expect(@counter.value).to eq 202
    population.fitness_target = 99999
    expect(population.fitness_target).to eq 99999
    population.evolve(2)
    expect(@counter.value).to eq 602
    set_function_return = population.set_fitness_target(200)
    expect(set_function_return).to eq population
    expect(population.fitness_target).to eq 200
    population.evolve(3)
    expect(@counter.value).to eq 602
  end
  
  it "can force all fitness recalculation" do
    population = Population.new(200, @genome, @counter.method(:increment))
    expect(!population.force_fitness_recalculation)
    expect(@counter.value).to eq 2
    population.evolve()
    expect(@counter.value).to eq 2
    population.force_fitness_recalculation = true
    expect(population.force_fitness_recalculation)
    population.evolve(2)
    expect(@counter.value).to eq 402
    set_function_return = population.set_force_fitness_recalculation(false)
    expect(set_function_return).to eq population
    expect(population.force_fitness_recalculation).to eq false
    population.evolve(3)
    expect(@counter.value != 402)
  end
end