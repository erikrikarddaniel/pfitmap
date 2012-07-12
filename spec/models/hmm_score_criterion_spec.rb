# == Schema Information
#
# Table name: hmm_score_criterions
#
#  id                :integer         not null, primary key
#  min_fullseq_score :float
#  hmm_profile_id    :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe HmmScoreCriterion do
  #common sequence source
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
  let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
  #Profile with higher score
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile_001) }
  let!(:hmm_result1) { FactoryGirl.create(:hmm_result, 
                                          hmm_profile: hmm_profile1, 
                                          sequence_source: sequence_source) }
  
  let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, 
                                              hmm_result: hmm_result1, 
                                              db_sequence: db_sequence1) }
  let!(:hmm_score_criterion1) { FactoryGirl.create(:hmm_score_criterion,
                                                   hmm_profile: hmm_profile1) }
  
  #Profile with lower score
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile) }
  let!(:hmm_result2) { FactoryGirl.create(:hmm_result, 
                                          hmm_profile: hmm_profile2, 
                                          sequence_source: sequence_source) }
  
  let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, 
                                              hmm_result: hmm_result2, 
                                              db_sequence: db_sequence1) }
  
  let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, 
                                              hmm_result: hmm_result2, 
                                              db_sequence: db_sequence2) }
  let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion,
                                                   hmm_profile: hmm_profile2) }
  
  #Independent profile
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  before do
    @hmm_score_criterion = HmmScoreCriterion.new(hmm_profile_id: 
                                                 hmm_profile.id, 
                                                 min_fullseq_score: 15.0)
  end
  subject{ @hmm_score_criterion }
  
  it{ should be_valid }
  it{ should respond_to(:min_fullseq_score) }
  it{ should respond_to(:hmm_profile) }
  it{ should respond_to(:hmm_profile_id) }
  it{ should respond_to(:evaluate?) }
  its(:hmm_profile) { should == hmm_profile }
  
  describe "without profile" do
    before do
      @hmm_score_criterion.hmm_profile_id = nil
    end
    it{ should_not be_valid }
  end

  describe "without min fullseq score" do
    before do
      @hmm_score_criterion.min_fullseq_score = nil
    end
    it{ should_not be_valid }
  end

  describe "when violating one for each hmm_profile" do
    before do
      @hmm_score_criterion.hmm_profile_id = hmm_profile1.id
    end
    it { should_not be_valid }
  end
  

  describe "evaluating db_sequence" do
    it "the best profile evaluates to true" do
      hmm_score_criterion1.evaluate?(db_sequence1,sequence_source).should be_true
    end
    it "a mediocre profile evaluates to false" do
      hmm_score_criterion1.evaluate?(db_sequence2, sequence_source).should be_false
    end
  end
end
