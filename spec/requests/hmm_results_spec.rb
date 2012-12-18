require 'spec_helper'

describe "HmmResults" do
  before do
    make_mock_admin
    login_with_oauth
  end
  subject { page }
  
  let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
  let!(:profile2) { FactoryGirl.create(:hmm_profile, name: "class 2" ) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:r1) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, sequence_source: sequence_source, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1, db_sequence: db_sequence) }
  let!(:hmm_db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }

  describe "show result" do
    before{ visit hmm_result_path(r1) }
    it {should have_content(profile1.name ) }
    it {should have_content(r1.executed.year.to_s) }
    it {should have_content('Listing HMM result-rows') }

    it "should have the correct result information" do
      page.should have_content(profile1.name)
      page.should have_content(r1.sequence_source.version)
    end
    
    it "should have the correct result row information" do
      r1.hmm_result_rows.each do |row|
        page.should have_content(row.fullseq_evalue.to_s )
        page.should have_content(result_row.fullseq_score.to_s)
      end
    end
  end
  describe "HMM score criteria" do
    before do
      visit hmm_result_path(r1)
    end
    it "without criteria" do
      page.should have_content("No criterion created for")
    end
    describe "with criteria" do
      let!(:hmm_score_criterion) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: profile1, min_fullseq_score: 500) }
      before do
        visit hmm_result_path(r1)
      end
      it "should be displayed" do
        page.should_not have_content("No criterion created for")
        page.should have_button("Update Hmm score criterion")
      end
      it "should be editable" do
        fill_in 'hmm_score_criterion_min_fullseq_score', :with => '800'
        click_button "Update Hmm score criterion"
        page.should have_content("Hmm score criterion was successfully updated.")
        profile1.hmm_score_criteria.first.min_fullseq_score.should == 800
      end
    end
  end

  
  describe "show result-rows" do
    before do
      visit hmm_result_row_path(result_row)
    end
    it "should have the correct result information" do
      page.should have_content(profile1.name)
      page.should have_content(r1.sequence_source.version)
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
