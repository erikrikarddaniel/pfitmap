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
  #Common sequence source
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  #two alternative sequences
  let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
  let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
  #Profile with higher score
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile_001) }
  let!(:inclusion_criterion1) { FactoryGirl.create(:inclusion_criterion, 
                                                  hmm_profile: hmm_profile1) }
  let!(:hmm_score_criterion1) { FactoryGirl.create(:hmm_score_criterion, 
                                                  inclusion_criterion: inclusion_criterion1) }
  let!(:hmm_result1) { FactoryGirl.create(:hmm_result, 
                                          hmm_profile: hmm_profile1, 
                                          sequence_source: sequence_source) }
  let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, 
                                              hmm_result: hmm_result1, 
                                              db_sequence: db_sequence1) }
  let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, 
                                              hmm_result: hmm_result1, 
                                              db_sequence: db_sequence1) }
  #Profile with lower score
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_00100) }
  #No criterions, they will be defined in the tests
  let!(:hmm_result2) { FactoryGirl.create(:hmm_result, 
                                          hmm_profile: hmm_profile2, 
                                          sequence_source: sequence_source) }
  # A row for the first sequence, to compare against profile1
  let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, 
                                              hmm_result: hmm_result2, 
                                              db_sequence: db_sequence1) }
  # A row for the second sequence, to test minimum score threshold
  let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, 
                                              hmm_result: hmm_result2, 
                                              db_sequence: db_sequence2) }
  
  # An independent profile
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile_001) }
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

  describe "when it violates uniqueness of one per profile" do
    before { @inclusion_criterion.hmm_profile_id = hmm_profile1.id}
    it { should_not be_valid }
  end

  describe "evaluating best profile for db_sequence" do
    let!(:inclusion_criterion2) { FactoryGirl.create(:inclusion_criterion, 
                                                     hmm_profile: hmm_profile2) }
    let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion, 
                                                     inclusion_criterion: inclusion_criterion2) }
    it "the best profile evaluates to true" do
      inclusion_criterion1.evaluate?(db_sequence1).should be_true
    end
    it "a mediocre profile evaluates to false" do
      inclusion_criterion2.evaluate?(db_sequence2).should be_false
    end
  end

  describe "evaluating another profile than the best for db_sequence" do
    let!(:inclusion_criterion2) { FactoryGirl.create(:inclusion_criterion, 
                                                     hmm_profile: hmm_profile2) }
    let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion, 
                                                     inclusion_criterion: inclusion_criterion2,
                                                     min_fullseq_score: 5.0) }
    #db_sequence1 has profile1 as the best, so even if we change the threshold below 
    #the actual score for profile2 it should be false.
    it "fails due to other better profile" do
      inclusion_criterion2.evaluate?(db_sequence1).should be_false
    end
  end
end
