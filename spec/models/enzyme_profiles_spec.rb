require 'spec_helper'

describe EnzymeProfile do
  let!(:class1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:profile1) { FactoryGirl.create(:hmm_profile) }
  let!(:enzyme_profile1) { FactoryGirl.create(:enzyme_profile, hmm_profile: profile1, enzyme: class1) }
  it "should handle the association" do
    profile1.enzymes.should include(class1)
    class1.hmm_profiles.should include(profile1)
  end
end
