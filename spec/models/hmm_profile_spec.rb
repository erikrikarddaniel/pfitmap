# == Schema Information
#
# Table name: hmm_profiles
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  version      :string(255)
#  parent_id    :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  protein_name :string(255)
#  hmm_logo     :string(255)
#

require 'spec_helper'

describe HmmProfile do
  let(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let(:hmm_profile_nrdbr2lox) { FactoryGirl.create(:hmm_profile_nrdbr2lox) }
  before do
    @hmm_profile = HmmProfile.create!(name: "Root HMM Profile", version: "20120328", protein_name: "all_proteins")
  end

  subject { @hmm_profile }

  it { should respond_to(:name) }
  it { should respond_to(:protein_name) }
  it { should respond_to(:version) }
  it { should respond_to(:hierarchy) }
  it { should respond_to(:parent_id) }
  it { should respond_to(:children) }
  it { should respond_to(:last_parent_id) }
  it { should respond_to(:hmm_score_criteria) }
  it { should respond_to(:inclusion_criteria) }
  it { should respond_to(:enzymes) }
  it { should respond_to(:db_sequence_best_profiles)}
  it { should respond_to(:best_profile_sequences) }
  it { should be_valid }
  
  describe "Should not be valid when name is not present" do
    before { @hmm_profile.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @hmm_profile.version = "" }
    it { should_not be_valid }
  end
  
  describe "Should not be valid when protein_name is not present" do
    before { @hmm_profile.protein_name = "" }
    it { should_not be_valid }
  end

  describe "One should be able to create a child profile from a profile" do
    subject do
      @child = @hmm_profile.children.create(
	name: "1st gen. child HMM profile",
	protein_name: 'NrdA',
	version: "20120328"
      )
    end
    it { should be_valid }
    it {  should respond_to(:name) }
    it {  should respond_to(:protein_name) }
    it { should respond_to(:all_parents_including_self) }
  end


  describe "inclusion criteria" do
    #two alternative sequences
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    #Common sequence source
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    #Profile with higher score
    let!(:hmm_score_criterion1) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, 
                                            hmm_profile: hmm_profile, 
                                            sequence_source: sequence_source) }
    let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, 
                                                hmm_result: hmm_result1, 
                                                db_sequence: db_sequence1) }
    #Profile with lower score
    let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile_nrdbr2lox) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, 
                                            hmm_profile: hmm_profile_nrdbr2lox, 
                                            sequence_source: sequence_source) }
    # A row for the first sequence, with low score to compare against profile1
    let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, 
                                                hmm_result: hmm_result2, 
                                                db_sequence: db_sequence1) }
    # A row for the second sequence, to test minimum score threshold
    let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, 
                                                hmm_result: hmm_result2, 
                                                db_sequence: db_sequence2) }
    it "correctly picks up the criteria array" do
      hmm_profile.inclusion_criteria.should == [hmm_score_criterion1]
    end

    it "correctly finds the score criterion" do 
      hmm_profile.hmm_score_criteria.should == [hmm_score_criterion1]
    end
    
    it "evaluates the best profile with high enough score" do
      hmm_profile.evaluate?(db_sequence1,sequence_source).should be_true
    end
    
    it "evaluates the best profile with score below threshold" do
      hmm_profile_nrdbr2lox.evaluate?(db_sequence2,sequence_source).should be_false
    end
    describe "Evaluates a profile that is not the best" do
      let!(:hmm_profile3) { FactoryGirl.create(:hmm_profile) }
      let!(:hmm_result3) { FactoryGirl.create(:hmm_result, 
                                              hmm_profile: hmm_profile3, 
                                              sequence_source: sequence_source) }
      let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, 
                                                  hmm_result: hmm_result3, 
                                                  db_sequence: db_sequence1) }
      let!(:hmm_score_criterion3) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile3, min_fullseq_score: 5.0) }
      it "with score above threshold" do
        hmm_profile3.evaluate?(db_sequence1,sequence_source).should be_false
      end
      it "with score below threshold" do
        hmm_profile_nrdbr2lox.evaluate?(db_sequence1,sequence_source).should be_false
      end
    end
    describe "evaluates a profile without a criterion" do
      let!(:hmm_profile4) { FactoryGirl.create(:hmm_profile) }
      let!(:hmm_result4) { FactoryGirl.create(:hmm_result, 
                                              hmm_profile: hmm_profile4, 
                                              sequence_source: sequence_source) }
      let!(:db_sequence4) { FactoryGirl.create(:db_sequence) }
      let!(:hmm_result_row4) { FactoryGirl.create(:hmm_result_row, 
                                                  hmm_result: hmm_result4, 
                                                  db_sequence: db_sequence4) }
      it "should be false" do
        hmm_profile4.evaluate?(db_sequence4, sequence_source).should be_false
      end
    end
    
  end

  describe "enzyme association" do
    let!(:enzyme) { FactoryGirl.create(:enzyme) }
    let!(:enzyme_profile) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme, hmm_profile: hmm_profile) }
    subject{hmm_profile}
    its(:enzymes) { should include( enzyme) }
  end

  describe "Best Profile reverse association" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result) do
      FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_source: sequence_source) 
    end
    let!(:hmm_result_row) do 
      FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result, db_sequence: db_sequence) 
    end

    it "has correct db_sequence association" do
      hmm_profile.best_profile_sequences(sequence_source).should include(db_sequence)
    end

  end

  describe "object's hierarchy" do
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile11) { FactoryGirl.create(:hmm_profile, parent: hmm_profile1) }
    let!(:hmm_profile12) { FactoryGirl.create(:hmm_profile, parent: hmm_profile1) } 
    let!(:hmm_profile111) { FactoryGirl.create(:hmm_profile, parent: hmm_profile11) }
    let!(:hmm_profile112) { FactoryGirl.create(:hmm_profile, parent: hmm_profile11) }
    let!(:hmm_profile1111) { FactoryGirl.create(:hmm_profile, parent: hmm_profile111) }
    
    describe "all_parents_including_self" do
      it "includes exactly what it should" do
        hmm_profile1.all_parents_including_self.should == [hmm_profile1]
        hmm_profile11.all_parents_including_self.should == [hmm_profile11, hmm_profile1]
        hmm_profile111.all_parents_including_self.should == [hmm_profile111, hmm_profile11, hmm_profile1]
      end
    end
    describe "last_parents" do
      it "includes exactly what it should" do
        HmmProfile.last_parents.should == [@hmm_profile, hmm_profile1, hmm_profile2]
      end
    end
  end
end
