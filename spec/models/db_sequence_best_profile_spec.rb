# == Schema Information
#
# Table name: db_sequence_best_profiles
#
#  db_sequence_id     :integer
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  hmm_result_row_id  :integer
#  fullseq_score      :float
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
      @view_row = DbSequenceBestProfile.find(:first, :conditions => {hmm_profile_id: hmm_profile1.id, sequence_source_id: sequence_source1.id, db_sequence_id: db_sequence3.id})
    end
    subject { @view_row }
    
    it { should respond_to(:hmm_profile) }
    it { should respond_to(:sequence_source) }
    it { should respond_to(:db_sequence) }
    it { should respond_to(:fullseq_score) }
    it { should respond_to(:hmm_result_row) }
    
    its(:hmm_profile) { should == hmm_profile1 }
    its(:sequence_source) { should == sequence_source1 }
    its(:db_sequence) { should == db_sequence3 }
    its(:fullseq_score) {should == hmm_result_row10.fullseq_score }
    its(:hmm_result_row) {should == hmm_result_row10 }
    
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
  describe "the stats" do
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source1) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source2) }
    let!(:pfitmap_sequence1) { FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release1, db_sequence: db_sequence2, hmm_profile: hmm_profile2) }
    let!(:pfitmap_sequence2) { FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release1, db_sequence: db_sequence3, hmm_profile: hmm_profile1) }
    let!(:pfitmap_sequence3) { FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release2, db_sequence: db_sequence1, hmm_profile: hmm_profile2) }
    let!(:pfitmap_sequence4) { FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release2, db_sequence: db_sequence2, hmm_profile: hmm_profile2) }
    let!(:pfitmap_sequence5) { FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release2, db_sequence: db_sequence3, hmm_profile: hmm_profile2) }


    it "gives the correct included numbers for source1, profile1" do
      stats = DbSequenceBestProfile.included_stats(hmm_profile1, sequence_source1)
      count, min, max  = stats
      count.should == 1
      min.should == 50.0
      max.should == 50.0
    end

    it "gives the correct included numbers for source1, profile2" do
      count, min, max  = DbSequenceBestProfile.included_stats(hmm_profile2, sequence_source1)
      count.should == 1
      min.should == 20.0
      max.should == 20.0
    end

    it "gives the correct included numbers for source2, profile1" do
      count, min, max  = DbSequenceBestProfile.included_stats(hmm_profile1, sequence_source2)
      count.should == 0
      min.should == nil
      max.should == nil
    end

    it "gives the correct included numbers for source2, profile2" do
      count, min, max  = DbSequenceBestProfile.included_stats(hmm_profile2, sequence_source2)
      count.should == 3
      max.should == 45.0
      min.should == 35.0
    end

    it "gives the correct not included numbers for source1 profile1" do
      count, min, max  = DbSequenceBestProfile.not_included_stats(hmm_profile1, sequence_source1)
      count.should == 0
      min.should == nil
      max.should == nil
    end

    it "gives the correct not included numbers for source1 profile2" do
      count, min, max  = DbSequenceBestProfile.not_included_stats(hmm_profile2, sequence_source1)
      count.should == 0
      min.should == nil
      max.should == nil
    end
  end
end
