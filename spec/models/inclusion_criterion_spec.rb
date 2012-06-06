# == Schema Information
#
# Table name: inclusion_criterions
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe InclusionCriterion do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  before do
    @inclusion_criterion = InclusionCriterion.new(hmm_profile_id: hmm_profile.id)
  end
  subject { @inclusion_criterion }
  
  it { should respond_to(:hmm_profile) }
  it { should be_valid }
  
  describe "without hmm profile id" do
    before { @inclusion_criterion.hmm_profile_id = nil }
    it { should_not be_valid}
  end
end
