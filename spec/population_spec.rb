require 'population'

GenomeMock = double("Genome")
KaryotypeMock = double("Karyotype")
GenomeMock.stub(:create_random){KaryotypeMock}
KaryotypeMock.stub(:breed){KaryotypeMock}
KaryotypeMock.stub(:mutate){KaryotypeMock}

class Counter
  attr_accessor :value
  def initialize
    @value = 0
  end
  def increment
    @value += 1
  end
end

describe Population do

  it "can be created at a specific size" do
    counter = Counter.new
    population = Population(200, GenomeMock, counter.method(:increment))
    expect(population.size).to eq 200
    expect(counter.value).to eq 200
  end
  
  it "can evolve" do
    counter = Counter.new
    population = Population(200, GenomeMock, counter.method(:increment))
    population.evolve()
    expect(counter.value).to eq 400
  end

  it "can evolve several times" do
    counter = Counter.new
    population = Population(200, GenomeMock, counter.method(:increment))
    population.evolve(2)
    expect(counter.value).to eq 600
  end
  
  it "has a mutation rate which default value is 1%" do
    population = Population(200, GenomeMock, counter.method(:increment))
    expect(population.mutation_rate).to eq 0.01
    population.mutation_rate = 0.02
    expect(population.mutation_rate).to eq 0.02
    set_function_return = population.set_mutation_rate(0.03)
    expect(set_function_return).to eq population
    expect(population.mutation_rate).to eq 0.03
  end
  
  it "has a keep alive rate which default value is 10%" do
    population = Population(200, GenomeMock, counter.method(:increment))
    expect(population.keep_alive_rate).to eq 0.1
    population.keep_alive_rate = 0.2
    expect(population.keep_alive_rate).to eq 0.2
    set_function_return = population.set_keep_alive_rate(0.3)
    expect(set_function_return).to eq population
    expect(population.keep_alive_rate).to eq 0.3
  end
end