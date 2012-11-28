require 'spec_helper'

describe "Authorization" do
  describe "signing in" do
    it "works!" do
      login_with_oauth
      page.should have_content('Signed in!')
    end
  end
  describe "When not logged in" do
    it "can visit the profile index page" do
      visit hmm_profiles_path
      page.should have_content('HMM Profiles')
    end
    it "cannot visit new hmm profile page" do
      visit new_hmm_profile_path
      page.should have_content('You are not authorized')
    end
  end

  

  describe "When logged in" do

    it "can log out" do
      login_with_oauth
      click_on 'Sign Out Bob Example'
      page.should have_content('You are now signed out!')
    end

    context "without being admin" do
      before do
        login_with_oauth
      end
      it "can visit the profile index page" do
        visit hmm_profiles_path
        page.should have_content('HMM Profiles')
      end

      it "cannot visit new hmm profile page" do
        visit new_hmm_profile_path
        page.should have_content('You are not authorized')
      end
    end
    
    context "as admin" do
      before do
        make_mock_admin
        login_with_oauth
      end
      it "can visit new hmm profile page" do
        warn "users: #{User.all}"
        visit new_hmm_profile_path
        page.should have_content('New HMM Profile')
      end
    end
  end
end
