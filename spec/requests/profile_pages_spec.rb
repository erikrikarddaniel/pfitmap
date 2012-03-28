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
      it { should have_content(profile.results.count) }
      it "should have the dates" do
        should have_content(m1.date.year)
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
