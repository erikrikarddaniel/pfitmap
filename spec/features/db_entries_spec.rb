require 'spec_helper'
# ========================================================================
# !!!!!TODO Note that this test was generated for table named HmmDBHit but
# has been altered since that table will be renamed to DBEntry.
# Go over the test and change references to HmmDBHit when renaming is done
# ========================================================================

describe "HmmDbHits" do
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:db_entry) { FactoryGirl.create(:db_entry, db_sequence: db_sequence) }    
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, sequence_source: sequence_source, hmm_profile: hmm_profile) }
  let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
  
  it "works! (now write some real specs)" do
    visit hmm_db_hits_path
  end

  describe "Index page" do
    before do
      visit hmm_db_hits_path
    end
    it "shows the correct content" do
      page.should have_content("New Hmm db hit")
      page.should have_content("Listing")
    end
    it "should display som information" do
      page.should have_content(db_entry.gi)
      page.should have_content(db_entry.desc)
    end
    
  end

  describe "Show page" do
    before do
      visit hmm_db_hit_path(db_entry)
    end
    it "should display some information headers" do
      page.should have_content("Gi")
      page.should have_content("Desc")
    end
    it "should display som information" do
      page.should have_content(db_entry.gi)
      page.should have_content(db_entry.desc)
    end
  end
  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end
      
    describe "edit page" do
      let!(:db_entry) { FactoryGirl.create(:db_entry) }
      before do
        visit edit_hmm_db_hit_path(db_entry)
      end
      it "can handle invalid parameters" do
        page.fill_in 'Gi', :with => ""
        click_button "Update Hmm db hit"
        page.should have_content("1 error prohibited")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Gi', :with => "12345"
        click_button "Update Hmm db hit"
        page.should have_content("successfully updated")
      end
    end
  end


end
