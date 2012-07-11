require 'spec_helper'

describe "Enzymes" do
  describe "GET /enzymes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get enzymes_path
      response.status.should be(200)
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
        visit new_enzyme_path()
      end
      it "can handle invalid parameters" do
        click_button "Create Enzyme"
        page.should have_content("The form contains 1 error")
        page.should have_content("#{hmm_profile.name}")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Name', :with => "Bobs' enzyme"
        page.select("#{hmm_profile.name}")
        click_button "Create Enzyme"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:enzyme) { FactoryGirl.create(:enzyme) }
      before do
        visit edit_enzyme_path(enzyme)
      end
      it "can handle invalid parameters" do
        page.fill_in 'Name', :with => ""
        click_button "Update Enzyme"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Name', :with => "Bobs' Enzyme"
        click_button "Update Enzyme"
        page.should have_content("successfully updated")
      end
    end
  end
end
