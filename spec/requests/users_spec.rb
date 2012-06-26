require 'spec_helper'

describe "Users" do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:admin){ FactoryGirl.create(:user_admin) }
  
  context "As guest user" do
    it "cannot access index page" do
      visit users_path
      page.should have_content("You are not authorized")
    end

    it "cannot access edit page" do
      visit edit_user_path(user)
      page.should have_content("You are not authorized")
    end
  end
      
  context "As admin user" do
    before do
      make_mock_admin
      login_with_oauth
    end

    it "can view users" do
      visit users_path
      page.should have_content(user.name)
    end
    
    it "can access user edit page" do
      visit edit_user_path(user)
      page.should have_content('Editing user')
    end
    
  end
end
  
