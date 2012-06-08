# == Schema Information
#
# Table name: hmm_profiles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  hierarchy  :string(255)
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe HmmProfile do
  let(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let(:hmm_profile_00101) { FactoryGirl.create(:hmm_profile_00101) }
  before do
    @hmm_profile = HmmProfile.create!(name: "Root HMM Profile", version: "20120328", hierarchy: "000")
  end

  subject { @hmm_profile }

  it { should respond_to(:name) }
  it { should respond_to(:version) }
  it { should respond_to(:hierarchy) }
  it { should respond_to(:parent_id) }
  it { should respond_to(:children) }
  it { should respond_to(:last_parent_id) }
  it { should respond_to(:hmm_score_criterion) }
  it { should be_valid }
  
  describe "Should not be valid when name is not present" do
    before { @hmm_profile.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @hmm_profile.version = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when hierarchy is not present" do
    before { @hmm_profile.hierarchy = "" }
    it { should_not be_valid }
  end

  describe "One should be able to create a child profile from a profile" do
    subject do
      @child = @hmm_profile.children.create(
	name: "1st gen. child HMM profile",
	version: "20120328",
	hierarchy: "000.00"
      )
    end
    it { should be_valid }
    it {  should respond_to(:name) }
  end

  describe "Profiles produced in the factory" do
    let(:hmm_profile_001) { FactoryGirl.create(:hmm_profile_001) }
    let(:hmm_profile_00100) { FactoryGirl.create(:hmm_profile_00100, parent: hmm_profile_001) }
    let(:hmm_profile_00101) { FactoryGirl.create(:hmm_profile_00101, parent: hmm_profile_001) }
    let(:hmm_profile_0010101){ FactoryGirl.create(:hmm_profile, parent: hmm_profile_00101) }
    
    it "should be able to find its last parent" do
      hmm_profile_0010101.last_parent_id.should == hmm_profile_001.id
    end
    
    it "should be able to list their closest children" do
      hmm_profile_001.children.should include(hmm_profile_00100)
    end
    
    it "should be able to list all last parents (root nodes)" do
      HmmProfile.last_parents().should include(hmm_profile_001)
    end
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
    let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile_00101) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, 
                                            hmm_profile: hmm_profile_00101, 
                                            sequence_source: sequence_source) }
    # A row for the first sequence, with low score to compare against profile1
    let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, 
                                                hmm_result: hmm_result2, 
                                                db_sequence: db_sequence1) }
    # A row for the second sequence, to test minimum score threshold
    let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, 
                                                hmm_result: hmm_result2, 
                                                db_sequence: db_sequence2) }
    it "correctly finds the score criterion" do 
      hmm_profile.hmm_score_criterion.should == hmm_score_criterion1
    end
    
    it "evaluates the best profile with high enough score" do
      hmm_profile.hmm_score_criterion.evaluate?(db_sequence1).should be_true
    end
    
    it "evaluates the best profile with score below threshold" do
      hmm_profile_00101.hmm_score_criterion.evaluate?(db_sequence2).should be_false
    end
    describe "Evaluates a profile that is not the best" do
      let!(:hmm_profile3) { FactoryGirl.create(:hmm_profile) }
      let!(:hmm_result3) { FactoryGirl.create(:hmm_result, 
                                              hmm_profile: hmm_profile3, 
                                              sequence_source: sequence_source) }
      let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row, 
                                                  hmm_result: hmm_result3, 
                                                  db_sequence: db_sequence1) }
      let!(:hmm_score_criterion3) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile3, min_fullseq_score: 5.0) }
      it "with score above threshold" do
        hmm_profile3.evaluate?(db_sequence1).should be_false
      end
      it "with score below threshold" do
        hmm_profile_00101.evaluate?(db_sequence1).should be_false
      end
    end

    
  end
end
