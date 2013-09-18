# == Schema Information
#
# Table name: enzymes
#
#  id           :integer         not null, primary key
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  abbreviation :string(255)
#  parent_id    :integer
#  name         :string(255)
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
end
