# == Schema Information
#
# Table name: db_sequence_best_profiles
#
#  db_sequence_id     :integer
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  hmm_result_row_id  :integer
#

require 'spec_helper'

describe DbSequenceBestProfile do
  # Hmm Profiles
  let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile)  }
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile)  }
  
  #Sequence sources
  let!(:sequence_source1) { FactoryGirl.create(:sequence_source) }
  let!(:sequence_source2)  { FactoryGirl.create(:sequence_source) }
  
  # Hmm Results
  let!(:hmm_result1){ FactoryGirl.create(:hmm_result, 
                                         sequence_source: sequence_source1, 
                                         hmm_profile: hmm_profile1) }
  let!(:hmm_result2){ FactoryGirl.create(:hmm_result, 
                                         sequence_source: sequence_source1, 
                                         hmm_profile: hmm_profile2) }
  let!(:hmm_result3){ FactoryGirl.create(:hmm_result, 
                                         sequence_source: sequence_source2, 
                                         hmm_profile: hmm_profile1) }
  let!(:hmm_result4){ FactoryGirl.create(:hmm_result, 
                                         sequence_source: sequence_source2, 
                                         hmm_profile: hmm_profile2) }

  # Db Sequences
  let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
  let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
  let!(:db_sequence3) { FactoryGirl.create(:db_sequence) }

  # Hmm Result Rows
  let!(:hmm_result_row1){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result1, 
                                            db_sequence: db_sequence1, 
                                            fullseq_score: 5.0) }
  let!(:hmm_result_row2){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result1, 
                                            db_sequence: db_sequence2, 
                                            fullseq_score: 10.0) }
  let!(:hmm_result_row3){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result2, 
                                            db_sequence: db_sequence1, 
                                            fullseq_score: 15.0) }
  let!(:hmm_result_row4){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result2, 
                                            db_sequence: db_sequence2, 
                                            fullseq_score: 20.0) }
  let!(:hmm_result_row5){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result3, 
                                            db_sequence: db_sequence1, 
                                            fullseq_score: 25.0) }
  let!(:hmm_result_row6){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result3, 
                                            db_sequence: db_sequence2, 
                                            fullseq_score: 30.0) }
  let!(:hmm_result_row7){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result4, 
                                            db_sequence: db_sequence1, 
                                            fullseq_score: 35.0) }
  let!(:hmm_result_row8){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result4, 
                                            db_sequence: db_sequence2, 
                                            fullseq_score: 40.0) }
  let!(:hmm_result_row9){ FactoryGirl.create(:hmm_result_row, 
                                            hmm_result: hmm_result4, 
                                            db_sequence: db_sequence3, 
                                            fullseq_score: 45.0) }
  let!(:hmm_result_row10){ FactoryGirl.create(:hmm_result_row, 
                                             hmm_result: hmm_result1, 
                                             db_sequence: db_sequence3, 
                                             fullseq_score: 50.0) }
  
  it "should create some rows in the views" do
    DbSequenceBestProfile.count.should == 6
  end

  describe "associations" do
    before do 
      @view_row = DbSequenceBestProfile.first
    end
    subject { @view_row }
    
    it { should respond_to(:hmm_profile) }
    it { should respond_to(:sequence_source) }
    it { should respond_to(:db_sequence) }
    it { should respond_to(:fullseq_score) }
    it { should respond_to(:hmm_result_row) }
    
    
  end
  describe "performs the correct query" do
    describe "for db_sequence1" do
      before do
        @view_row1 = db_sequence1.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source2.id)
        @view_row2 =  db_sequence1.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source1.id)
      end
      it "has correct best profile" do
        @view_row1.hmm_profile.should == hmm_profile2
        @view_row2.hmm_profile.should == hmm_profile2
      end
      
      it "has correct score" do
        @view_row1.fullseq_score.should == 35.0
        @view_row2.fullseq_score.should == 15.0
      end
    end
    describe "for db_sequence2" do
      before do
        @view_row1 = db_sequence2.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source2.id)
        @view_row2 = db_sequence2.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source1.id)
      end

      it "has correct best profile" do
        @view_row1.hmm_profile.should == hmm_profile2
        @view_row2.hmm_profile.should == hmm_profile2
      end

      it "has correct score" do
        @view_row1.fullseq_score.should == 40.0
        @view_row2.fullseq_score.should == 20.0
      end
    end
    
    describe "for db_sequence3" do
      before do
        @view_row1 = db_sequence3.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source2.id)
        @view_row2 = db_sequence3.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source1.id)
      end

      it "has correct best profile" do
        @view_row1.hmm_profile.should == hmm_profile2
        @view_row2.hmm_profile.should == hmm_profile1
      end
      
      it "has correct score" do
        @view_row1.fullseq_score.should == 45.0
        @view_row2.fullseq_score.should == 50.0
      end
    end
    
  end
end
