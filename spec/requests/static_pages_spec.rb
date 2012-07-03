require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'RNRdb') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
    it { should have_tag('li', :text => 'Sign in' ) }
  end

  describe 'omniauth' do
    context "as guest" do
      it "has the right link" do
        login_with_oauth
        visit root_path    
        page.should have_content("Sign Out Bob Example")  
      end
    end

    context "as admin" do
      it "has the right links" do
        make_mock_admin
        login_with_oauth
        visit root_path
        page.should have_content("Users")
        page.should have_content("Sign Out Bob Example")
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
  it "should have the right links on the layout" do
    visit root_path
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('')
  end
end
