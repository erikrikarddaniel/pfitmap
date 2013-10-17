require 'spec_helper'

describe "HmmResultRows" do
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
  let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1, db_sequence: db_sequence) }
  let!(:db_entry) { FactoryGirl.create(:db_entry, db_sequence: db_sequence) }
  let!(:hmm_alignment1) { FactoryGirl.create(:hmm_alignment, hmm_result_row: hmm_result_row) }
  let!(:hmm_alignment2) { FactoryGirl.create(:hmm_alignment, hmm_result_row: hmm_result_row, hmm_line: "genlsenyprvnlnpikypwakefykk") }


  describe "show result row" do 
    before{ visit hmm_result_row_path(hmm_result_row) }
    it {should have_content(profile1.name) }
    it { should have_content(db_entry.db) }
    it { should have_content(hmm_alignment1.hmm_line) }
    it { should have_content(hmm_alignment2.hmm_line) }
    it { should have_content(hmm_alignment1.target_line) }
    it { should have_content(hmm_alignment1.pp_line) }
  end
  
  describe "links works" do
    before{ visit hmm_result_row_path(hmm_result_row) }

    it "navigates back" do
      click_on 'Back'
      page.should have_content('HMM Result')
    end

    it "navigates to edit" do
      click_on 'Edit'
      page.should have_content('Editing')
    end
  end
end
