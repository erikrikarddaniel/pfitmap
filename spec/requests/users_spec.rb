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
      page.should have_content("Your are not authorized")
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
      page.should have_content(user.name)
    end

    it "can demote admin user" do
      visit edit_user_path(admin)
      click_on "Demote to guest"
      admin.role.should == 'guest'
    end
    
    it "can promote guest user" do
      visit edit_user_path(user)
      click_on "Promote to admin"
      user.role.should == 'admin'
    end
    
  end
end
  
