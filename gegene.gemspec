Gem::Specification.new do |s|
  s.name        = 'gegene'
  s.version     = '1.0.0'
  s.summary     = "Genetic algorithm helpers"
  s.description = "Framework for fast genetic algorithm development"
  s.authors     = ["Alexandre Ignjatovic"]
  s.email       = 'alexandre.ignjatovic@gmail.com'
  s.license     = 'MIT'
  s.files       = [
      "lib/allele.rb",
      "lib/chromosome.rb",
      "lib/gegene.rb",
      "lib/gene.rb",
      "lib/genome.rb",
      "lib/karyotype.rb",
      "lib/population.rb",
      "example/adding_gene_type.rb",
      "example/one_max.rb",
      "example/simple.rb"
    ]
  s.homepage    = 'https://github.com/bankair/gegene'
end