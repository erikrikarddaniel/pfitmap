require 'spec_helper'

describe EnzymeProtein do
  let!(:class1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:protein1) { FactoryGirl.create(:protein) }
  let!(:enzyme_protein1) { FactoryGirl.create(:enzyme_protein, protein: protein1, enzyme: class1) }
  it "should handle the association" do
    protein1.enzymes.should include(class1)
    class1.proteins.should include(protein1)
  end
end
