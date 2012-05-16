require 'spec_helper'

describe "HmmResults" do
  subject { page }
  
  let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
  let!(:profile2) { FactoryGirl.create(:hmm_profile, name: "class 2" ) }
  let!(:sequence_db) { FactoryGirl.create(:sequence_db) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:r1) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, sequence_db: sequence_db, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1, db_sequence: db_sequence) }
  let!(:hmm_db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }

  describe "show result" do
    before{ visit hmm_result_path(r1) }
    it {should have_content(profile1.name ) }
    it {should have_content(r1.executed.year.to_s) }
    it {should have_content('Listing HMM result-rows') }

    it "should have the correct result information" do
      page.should have_content(profile1.name)
      page.should have_content(r1.sequence_db.version)
    end
    
    it "should have the correct result row information" do
      r1.hmm_result_rows.each do |row|
        page.should have_content(row.fullseq_evalue.to_s )
        page.should have_content(result_row.fullseq_score.to_s)
      end
    end
  end

  
  describe "show result-rows" do
    before do
      visit hmm_result_row_path(result_row)
    end
    it "should have the correct result information" do
      page.should have_content(profile1.name)
      page.should have_content(r1.sequence_db.version)
    end
  end

  describe "delete result" do
    before do
      visit hmm_result_path(r1)
      click_on "Delete"
    end
    it "should destroy the result" do
      page.should_not have_content(r1.executed.to_formatted_s(:long))
    end
  end

  describe "show index page" do
    before do
      visit hmm_results_path
    end
    it "should display some content" do
      page.should have_content(r1.executed.to_formatted_s(:long))
    end
  end
end
