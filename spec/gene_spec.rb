require 'gene'

describe Gene do

  before(:each) do
  end
  
  it "create an integer allele with a value" do
    gene = Gene.Integer(-20, 20)
    allele = gene.create_random
    expect(allele.value.between?(-20, 20))
  end

  it "create a float allele with a value" do
    gene = Gene.Integer(-2.0, 2.0)
    allele = gene.create_random
    expect(allele.value.between?(-2, 2))
  end

  it "create an allele from an enum" do
    enum_values_array = [1, 2, 3]
    gene = Gene.Enum(enum_values_array)
    allele = gene.create_random
    expect(enum_values_array).to include(allele.value)
    previous_value = allele.value
    allele.mutate
    expect(previous_value != allele.value).to be_true
  end

end