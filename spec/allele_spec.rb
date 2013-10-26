require 'allele'
require 'gene'

describe Allele do
  
  before(:each) do
    @gene_mock = double(Gene)
    @gene_mock.stub(:mutate){1664}
  end

  it "contains a value" do
    allele = Allele.new(@gene_mock, 13)
    expect(allele.value).to eq 13
  end
  
  it "can mutate" do
    allele = Allele.new(@gene_mock, 13)
    allele.mutate
    expect(allele.value).to eq 1664
  end

end