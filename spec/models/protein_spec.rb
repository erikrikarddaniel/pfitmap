# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Protein do
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_nrdb) }
  let!(:enzyme1) { FactoryGirl.create(:enzyme_class_1) }
  let!(:enzyme_profile1) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme1, hmm_profile: hmm_profile1) }
  describe "initialization" do
    describe "with maximum a single enzyme" do
      before do
        Protein.initialize_proteins
      end
      it "should have created some proteins" do
        Protein.all.should_not == []
        Protein.count.should == 3
      end
    end
    describe "with multiple enzymes" do
      let!(:enzyme2) { FactoryGirl.create(:enzyme) }
      let!(:enzyme_profile2) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme2, hmm_profile: hmm_profile1) }
      before do
        Protein.initialize_proteins
      end
      it "should have created some proteins" do
        Protein.all.should_not == []
        Protein.count.should == 3
      end
      it "gets the associations right" do
        enzyme2.proteins.count.should == 1
        enzyme1.proteins.count.should == 1
      end
    end
    
  end
end
