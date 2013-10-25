
class Gene  
  def mutate(allele)
    raise "the 'mutate' function must be overloaded in the inheriting class."
  end

  def random_allele_value
    raise "the 'random_allele_value' function must be overloaded in the inheriting class."
  end

  def create_random
    Allele.new(self, self.random_allele_value)
  end
end

class NumericGene < Gene
  attr_accessor :min, :max
  def initialize(min, max)
    raise "max (#{max}) must be greater than min (#{min})" if max <= min
    @min = min
    @max = max
  end

  def mutate(previous_value) self.random end
end 

class IntegerGene < NumericGene
  def initialize(min, max) super(min, max) end
  
  def random_allele_value() rand(self.min..self.max) end
end

class FloatGene < NumericGene
  def initialize(min, max) super(min, max) end
  
  def random_allele_value
    rand() * (self.max - self.min) + self.min
  end
end

class EnumGene < Gene
  attr_accessor :enum_values

  def initialize(enum_values)
    raise "EnumGene initialization require an Array" unless enum_values.is_a? Array
    raise "EnumGene require at least two values" unless enum_values.size > 1
    @enum_values = enum_values
  end
  
  def random_allele_value
    @enum_values[rand @enum_values.size]
  end
  
  def mutate(previous_value)
    new_value = self.random_allele_value
    while new_value == previous_value
      new_value = self.random_allele_value
    end
    new_value
  end
end

class Gene
  def self.Integer(min, max) IntegerGene.new(min, max) end
  def self.Float(min, max) FloatGene.new(min, max) end
  def self.Enum(enum_values) EnumGene.new(enum_values) end
end