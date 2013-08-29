require 'spec_helper'

describe "HmmScoreCriteria" do
  describe "GET /hmm_score_criteria" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit hmm_score_criteria_path
    end
  end

  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end
    describe "new page" do
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      before do
        visit new_hmm_score_criterion_path()
      end
      it "can handle invalid parameters" do
        click_button "Create Hmm score criterion"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'hmm_score_criterion_min_fullseq_score', :with => "10.0"
        page.select("#{hmm_profile.name}")
        click_button "Create Hmm score criterion"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:hmm_score_criterion) { FactoryGirl.create(:hmm_score_criterion) }
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      before do
        visit edit_hmm_score_criterion_path(hmm_score_criterion)
      end
      it "can handle invalid parameters" do
        page.fill_in 'hmm_score_criterion_min_fullseq_score', :with => ""
        click_button "Update Hmm score criterion"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'hmm_score_criterion_min_fullseq_score', :with => "10.0"
        page.select("#{hmm_profile.name}")
        click_button "Update Hmm score criterion"
        page.should have_content("successfully updated")
      end
    end
  end
end
