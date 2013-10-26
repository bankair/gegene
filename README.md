gegene
======
A generic framework for genetic algorithm fast development in Ruby

Introduction
------------

>In the computer science field of artificial intelligence, a genetic algorithm (GA) is a search heuristic that mimics the process of natural selection. This heuristic (also sometimes called a metaheuristic) is routinely used to generate useful solutions to optimization and search problems.[1] Genetic algorithms belong to the larger class of evolutionary algorithms (EA), which generate solutions to optimization problems using techniques inspired by natural evolution, such as inheritance, mutation, selection, and crossover.

from http://en.wikipedia.org/wiki/Genetic_algorithm

In order to offer a fast prototyping framework for genetic algorithm, I created gegene (French shorter for Eugene).

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


