require 'spec_helper'

describe "Profile pages" do
 
  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:profile, name: "class 1")
      FactoryGirl.create(:profile, name: "class 2")
      visit profiles_path 
    end
    it { should have_selector('h1', text: 'Listing profiles')}
    it { should have_selector('title', text: full_title('Profiles')) }
    
    it "should list each profile" do
      Profile.all.each do |profile|
        page.should have_selector('li', text: profile.name)
      end
    end
  end

  describe "Showing a profile" do
    let(:profile) { FactoryGirl.create(:profile) }
    let!(:m1) do
      FactoryGirl.create(:result, profile: profile, date: 1.day.ago)
    end
    let!(:m2) do
      FactoryGirl.create(:result, profile: profile, date: 3.days.ago)
    end
    
    before {visit profile_path(profile) }

    it { should have_selector('h1', text: profile.name) }
    it { should have_selector('title', text: profile.name) }

    describe "Results" do
      it { should have_content(m1.date.class) }
      it { should have_content(profile.results.count) }
      end
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
  
  describe "results associations" do
    
    before { @profile.save }
    let!(:older_result) do
      FactoryGirl.create(:result, profile: @profile, date: 2.day.ago)
    end
    let!(:newer_result) do
      FactoryGirl.create(:result, profile: @profile, date: 1.day.ago)
    end
    it "should have the right results in the right order" do
      @profile.results.should == [newer_result, older_result]
    end
  end
end
