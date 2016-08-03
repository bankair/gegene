$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gegene/version'
Gem::Specification.new do |s|
  s.name        = 'gegene'
  s.version     = Gegene::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Genetic algorithm helpers"
  s.description = "Framework for genetic algorithm fast development"
  s.authors     = ["Alexandre Ignjatovic"]
  s.email       = 'alexandre.ignjatovic@gmail.com'
  s.license     = 'MIT'
  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.rubocop_todo.yml
    |.*\.eps
    )$}x
  end
  s.homepage    = 'https://github.com/bankair/gegene'
end
