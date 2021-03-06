require 'spec_helper'

describe "DbSequences" do
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, sequence_source: sequence_source, hmm_profile: hmm_profile) }
  let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }

  it "works! (now write some real specs)" do
    visit db_sequences_path
  end

  describe "Index page" do
    before do
      visit db_sequences_path
    end
  end

  describe "Show page" do
    before do
      visit db_sequence_path(db_sequence)
    end
    it "should display some information headers" do
      page.should have_content("Result Rows")
      page.should have_content("Best HMM Profile(s):")
    end
    it "should display som information" do
      page.should have_content(hmm_result_row.fullseq_evalue)
      page.should have_content(hmm_profile.name)
    end
  end

  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end
    describe "new page" do
      before do
        visit new_db_sequence_path()
      end
      it "can handle invalid parameters" do     
      end
      
      it "can handle valid parameters" do
        click_button "Create Db sequence"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
      before do
        visit edit_db_sequence_path(db_sequence)
      end
      it "can handle invalid parameters" do
      end
      
      it "can handle valid parameters" do
        click_button "Update Db sequence"
        page.should have_content("successfully updated")
      end
    end
  end
end
