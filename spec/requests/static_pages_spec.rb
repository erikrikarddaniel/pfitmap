require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do
    
    it "should have the content 'Home'" do
      visit root_path
      page.should have_content('Home')
    end
    
    it "should not have custom title" do
      visit root_path
      page.should_not have_selector('title', :text => "RNRdb | Home")
    end
    
    it "should have base title" do
      visit root_path
      page.should have_selector('title', :text => "RNRdb")
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      visit help_path
      page.should have_content('Help')
    end
    
    it "should have the right title" do
      visit help_path
      page.should have_selector('title', :text => "RNRdb | Help")
    end
  end
  describe "Contact page" do
    
    it "should have the content 'at'" do
      visit contact_path
      page.should have_content('at')
    end

    it "should have the right title" do
      visit contact_path
      page.should have_selector('title', :text => "RNRdb | Contact")
    end
  end
end
