# == Schema Information
#
# Table name: hmm_profile_release_statistics
#
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  pfitmap_release_id :integer
#  n                  :integer(8)
#  min_fullseq_score  :float
#  max_fullseq_score  :float
#

require 'spec_helper'

describe HmmProfileReleaseStatistic do
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

  let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source1 ) }
  let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source2 ) }

  let!(:pfitmap_sequence1) { FactoryGirl.create(:pfitmap_sequence, 
                                                db_sequence: db_sequence3, 
                                                pfitmap_release: pfitmap_release1,
                                                hmm_profile: hmm_profile1) }
  
  it "should not be empty" do
    HmmProfileReleaseStatistic.all.should_not == []
  end
  
  describe "has reverse associations" do
    it "for profiles" do
      hmm_profile1.hmm_profile_release_statistics.count.should == 1
      hmm_profile2.hmm_profile_release_statistics.count.should == 2
    end
    it "for sequence_sources" do
      sequence_source1.hmm_profile_release_statistics.count.should == 2
    end
    it "for pfitmap_releases" do
      pfitmap_release1.hmm_profile_release_statistics.count.should == 1
    end
  end
  
end
