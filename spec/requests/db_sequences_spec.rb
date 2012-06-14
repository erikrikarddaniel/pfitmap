require 'spec_helper'

describe "DbSequences" do
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }

  it "works! (now write some real specs)" do
    get db_sequences_path
    response.status.should be(200)
  end

  describe "Index page" do
    before do
      visit db_sequences_path
    end
    it "shows the correct content" do
      page.should have_content("New Db sequence")
      page.should have_content("Listing")
    end
  end

  describe "Show page" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result) { FactoryGirl.create(:hmm_result, sequence_source: sequence_source, hmm_profile: hmm_profile) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    before do
      visit db_sequence_path(db_sequence)
    end
    it "should display some information headers" do
      page.should have_content("Result Rows")
      page.should have_content("Best HMM Profile:")
    end
    it "should display som information" do
      page.should have_content(hmm_result_row.target_name)
      page.should have_content(hmm_profile.name)
    end
  end
end
