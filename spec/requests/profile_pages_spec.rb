require 'spec_helper'

describe "Profile pages" do
 
  subject { page }
  
  describe "profile header should contain profiles" do
    before { visit profiles_path }
    it { should have_selector('h1', text: 'Listing profiles')}
    it { should have_selector('title', text: full_title('Profiles')) }
  end

  describe "Showing a profile" do
    let(:profile) { FactoryGirl.create(:profile) }
    before {visit profile_path(profile) }

    it { should have_selector('h1', text: profile.name) }
    it { should have_selector('title', text: profile.name) }
  end
  
  describe "Creating new profile" do
    before { visit new_profile_path }
    
    describe "with invalid information" do
      it "should not create a profile" do
        expect { click_button "Create Profile" }.not_to change(Profile, :count)
      end
    end

    describe "with valid information" do
        before do
          fill_in "Name", with: "Example Profile"
        end

        it "should create a profile" do
        expect do 
          click_button "Create Profile"
        end.to change(Profile, :count).by(1)

      end

    end
  end

end

describe Profile do
before do
  @profile = Profile.new(name: "Example Profile")
end
  subject { @profile }
  it { should respond_to(:results)}
end
