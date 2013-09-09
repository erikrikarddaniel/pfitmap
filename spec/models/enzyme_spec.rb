# == Schema Information
#
# Table name: enzymes
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  parent_id    :integer
#  abbreviation :string(255)
#  enzymeclass  :string(255)
#  subclass     :string(255)
#  group        :string(255)
#  subgroup     :string(255)
#  subsubgroup  :string(255)
#

require 'spec_helper'

describe Enzyme do
  before do
    @enzyme = Enzyme.new(name: "RNR EX", abbreviation: "EX")
  end
  subject{ @enzyme }

  it { should respond_to(:name) }
  it { should respond_to(:hmm_profiles) }
  it { should respond_to(:enzyme_profiles) }
  it { should respond_to(:abbreviation) }
  it { should respond_to(:hierarchy) }

  it { should respond_to(:enzymeclass) }
  it { should respond_to(:subclass) }
  it { should respond_to(:group) }
  it { should respond_to(:subgroup) }
  it { should respond_to(:subsubgroup) }
  
  describe "relations" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:enzyme) { FactoryGirl.create(:enzyme) }
    let!(:enzyme_profile) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme, hmm_profile: hmm_profile) }
    subject{enzyme}
    
    its(:hmm_profiles) { should include(hmm_profile) }
  end

  describe "object hierarchy" do
    let!(:enzyme2) { FactoryGirl.create(:enzyme, parent: @enzyme) }
    
    it "should work" do
      enzyme2.parent.should be(@enzyme)
      @enzyme.children.should include(enzyme2)
      enzyme2.hierarchy.should == "EX:ENZ"
    end
  end
  describe "fills row enzyme information" do
    #let!(:enzyme_row) { Enzyme.create(name: "Test", abbreviation: "T", enzymeclass: "EnzClass", subclass: "EnzSubClass", group: "EnzGroup", subgroup: "EnzSubGroup", subsubgroup: "EnzSubSubGroup" )}
    let!(:enzyme_row) { FactoryGirl.create(:enzyme_row) }
    it "should be created " do
      enzyme_row.group.should == "EnzGroup"
    end
  end
end
