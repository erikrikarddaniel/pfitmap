require 'spec_helper'

describe "HmmResults" do
  subject { page }
  
  let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
  let!(:profile2) { FactoryGirl.create(:hmm_profile, name: "class 2" ) }
  let!(:sequence_db) { FactoryGirl.create(:sequence_db) }
  let!(:r1) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, sequence_db: sequence_db, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1) }
  let!(:sequence) { FactoryGirl.create(:hmm_db_hit) }
  before do
    @relation = DbSequence.new(hmm_result_row_id: result_row.id, hmm_db_hit_id: sequence.id)
    @relation.save
  end

  describe "show result" do
    before{ visit hmm_result_path(r1) }
    it {should have_content(profile1.name ) }
    it {should have_content(r1.executed.year.to_s) }
    it {should have_content('Listing HMM result-rows') }
    
    it "should list each result row id" do
      r1.hmm_result_rows.each do |row|
        page.should have_content(row.id.to_s )
      end
    end
  end
  
  describe "show result-rows" do
    before do
      visit hmm_result_row_path(result_row)
    end
    it "should have the correct content" do
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
