# A Gene can take different values, randomly mutate.
class Gene
  def mutate(_allele)
    raise_missing_impl :mutate
  end

  def random_allele_value
    raise_missing_impl :random_allele_value
  end

  def create_random
    Allele.new(self, random_allele_value)
  end

  private

  MISSING_IMPL_ERR_FMT =
    "the '%s' function must be overloaded in the inheriting class.".freeze

  def raise_missing_impl(func)
    raise MISSING_IMPL_ERR_FMT % func
  end
end

# Root class for all numeric genes
class NumericGene < Gene
  attr_accessor :min, :max
  def initialize(min, max)
    raise "max (#{max}) must be greater than min (#{min})" if max <= min
    @min = min
    @max = max
  end

  def mutate(previous_value)
    next_value = random_allele_value
    next_value = random_allele_value while next_value == previous_value
    next_value
  end
end

# Integer gene class
class IntegerGene < NumericGene
  def random_allele_value
    rand(min..max)
  end
end

# Float gene class
class FloatGene < NumericGene
  def random_allele_value
    rand * (max - min) + min
  end
end

# Enumeration gene class
class EnumGene < Gene
  attr_accessor :enum_values

  def initialize(enum_values)
    unless enum_values.is_a? Array
      raise 'EnumGene initialization require an Array'
    end
    raise 'EnumGene require at least two values' unless enum_values.size > 1
    @enum_values = enum_values
  end

  def random_allele_value
    @enum_values[rand @enum_values.size]
  end

  def mutate(previous_value)
    new_value = random_allele_value
    new_value = random_allele_value while new_value == previous_value
    new_value
  end
end

# Gene class build methods
class Gene
  def self.Integer(min, max)
    IntegerGene.new(min, max)
  end

  def self.Float(min, max)
    FloatGene.new(min, max)
  end

  def self.Enum(enum_values)
    EnumGene.new(enum_values)
  end
end
