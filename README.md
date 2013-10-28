gegene
======
A generic framework for genetic algorithm fast development in Ruby

Introduction
------------

>In the computer science field of artificial intelligence, a genetic algorithm (GA) is a search heuristic that mimics the process of natural selection. This heuristic (also sometimes called a metaheuristic) is routinely used to generate useful solutions to optimization and search problems.[1] Genetic algorithms belong to the larger class of evolutionary algorithms (EA), which generate solutions to optimization problems using techniques inspired by natural evolution, such as inheritance, mutation, selection, and crossover.

from http://en.wikipedia.org/wiki/Genetic_algorithm

In order to offer a fast prototyping framework for genetic algorithm, I created gegene (French shorter for Eugene).

With gegene, all you got to do in order to use genetic algorithms to solve a problem is:

1. define the genome of your solutions in terms of gene type and chromosome organisation (eq: write an array of hashes)
2. define the way you would like to evaluate each individuals (eq: write a fitness function which takes a karyotype as parameter)
3. create a population of individuals (eq: instantiates a Population object)
4. evolve ! (eq: run Population.evolve())
5. all your solutions are sorted by fitness value (fittest first) in Population.karyotypes.

Overview
--------

### Example

In the following code, we use gegene to find a and b so _a*a + b = 12_, with a included in [0,5], and b included in [-5,5]:
```Ruby
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
```

The result could be :

	a:4 b:-4 => a*a + b = 12

or

	a:3 b:3 => a*a + b = 12

_Note: this source code is available 'in example/simple.rb'_

### Features

At this very moment, gegene features:

* Inheritance
* Mutation
* Non linear selection
* A pretty cool name

### What will come next ?

My next moves will be: 

* Implementing the cross-over mechanism
* Cleaning, commenting and enhance my ugly beginner's code

Tutorial
--------

*This tutorial is available in 'example/one_max.rb'*

Let's consider the one max problem (an explanation can be found here : http://tracer.lcc.uma.es/problems/onemax/onemax.html ), where the goal is  maximizing the number of ones of an array of bits.

For this example, we'll use an array of 3 bits, named v1, v2 and v3.
Obviously, the solution to this problem would be:

* v1 = 1
* v2 = 1
* v3 = 1

Let's see if gegene is able to figure this out !

### Setting the genome description

First of all, you will need to add the following line to the top of your script:
```Ruby
require 'gegene'
```

If your lib path contains gegene, your script should still execute well.

Then, we have to figure out a way to describe the potential solutions to this problem.
Obviously, there is three variables to this problem (v1, v2 & v3), so we will use a genome containing 3 genes.
Each of these gene allow 0 or 1 as allele's value, so we will use an integer gene, whose range of values will be [0,1]. Do not add this source code to your script for the moment:
```Ruby
Gene.Integer(0, 1)
```

In order to maximize the diversity of combinations, well describe three chromosome descriptions, each of them containing an integer gene and named after the corresponding variable:
```Ruby
# Follow a genome description for the one max problem:
genome_description = [
    { v1: Gene.Integer(0,1) },
    { v2: Gene.Integer(0,1) },
    { v3: Gene.Integer(0,1) }
  ]
```

### Defining a fitness function

Next, we have to define the fitness function. This one is a pretty simple one, as we can sum the three values in order to score a karyotype:
```Ruby
# Here is the fitness function of the one max problem:
def fitness(karyotype)
  karyotype[:v1] + karyotype[:v2] + karyotype[:v3]
end
```

_Note that each of the karyotype 's allele can be accessed through its gene name_
The parameter of the fitness function is a [karyotype]( http://en.wikipedia.org/wiki/Karyotype). It contains all the chromosomes of a specific individual of our population.

### Creating and making a population evolve

Now that we are happy with our genome and fitness function, we have to create a population:
```Ruby
# We create a population of six individuals with the previous desc & func:
population = Population.new(6, genome_description, method(:fitness))
````

We already know the result of our fitness function for the best solution, so we can set the fitness target of our population. If the fitness target is reached, the population will stop evolving. A good usage to the fitness target is setting it to an acceptable score to avoid endless processing of a population with very small enhancement of the solutions.
```Ruby
# As we known the best solution for the one max problem, we set a
# fitness target of 3 (1+1+1).
population.fitness_target = 3
````

As the population contains only 6 individuals, we set a high mutation rate in order to introduce "new blood" at each iteration:
```Ruby
# As the population is quite small, we add a little more funk to our
# evolution process by setting a 30% mutation rate
population.mutation_rate = 0.3
```

Let me introduce to you.... Evolution !
```Ruby
# Let's go for some darwinist fun !
population.evolve(10)
````

In order to examine the best solution found, you can check the array of karyotypes (sorted by fitness value) describing the current population state:
```Ruby
# population.karyotypes is sorted by fitness score, so we can assume that
# the first element is the fittest
best_karyotype = population.karyotypes[0]

puts "Best karyotype scored #{best_karyotype.fitness}:"
[:v1, :v2, :v3].each {|x| puts "    #{x.to_s}:#{best_karyotype[x]}" }
````

This code should display:

	Best karyotype scored 3:
    	v1:1
    	v2:1
    	v3:1

Congratulations for your first evolution with gegene !

More details on the genes
-------------------------

### Available Gene types

* Gene.Integer(min, max): An integer, randomly selected in the range [min, max].
* Gene.Float(min, max): A float, randomly selected in the range [min, max].
* Gene.Enum(values_array): A value from a set of values provided in an array.

### Adding new gene types

If needed, you are able to add gene type to any project.
In order to do so, you have to create a class inheriting from the Gene class.
This class *must* provide implementation for two methods:

````Ruby
def random_allele_value()
end
````
Create a random value, according to the set of rules you choosed (ex: BooleanGene should return true or false, on a random basis)

````Ruby
def mutate(previous_value)
end
````
Create a mutated value, which can (but not necessarily) depends on the previous value an allele used to carry.

An example of gene type creation is available in 'example/adding_gene_type.rb'.
