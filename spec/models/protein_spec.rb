# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Protein do
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_nrdb) }

  describe "initialization" do
    before do
      Protein.initialize_proteins
    end
    it "should have created some proteins" do
      Protein.all.should_not == []
      Protein.count.should == 1
    end
  end
end
