require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do
    
    it "should have the content 'Home'" do
      visit '/static_pages/home'
      page.should have_content('Home')
    end
    
    it "should not have custom title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', :text => "RNRdb | Home")
    end
    
    it "should have base title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "RNRdb")
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
    
    it "should have the right title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "RNRdb | Help")
    end
  end
  describe "Contact page" do
    
    it "should have the content 'at'" do
      visit '/static_pages/contact'
      page.should have_content('at')
    end

    it "should have the right title" do
      visit '/static_pages/contact'
      page.should have_selector('title', :text => "RNRdb | Contact")
    end
  end
end
