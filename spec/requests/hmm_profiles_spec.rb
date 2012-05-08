require 'spec_helper'

describe "Hmm Profile Pages" do
  # before(:each) do
  #   @hmm_profile_001 = FactoryGirl.create(:hmm_profile_001)
  #   @hmm_profile_00100 = FactoryGirl.create(:hmm_profile_00100)
  # end
    
  subject { page }
  
  describe "index" do
    let(:profile1){FactoryGirl.create(:hmm_profile, name: "class 1") }
    let(:profile2) {FactoryGirl.create(:hmm_profile, name: "class 2")}
    before{ visit hmm_profiles_path } 

    it { should have_selector('h1', text: 'Listing HMM-Profiles')}
    it { should have_selector('title', text: full_title('HMM Profiles')) }
    it { should have_content('') } 
    
    it "should list each profile" do
      HmmProfile.all.each do |profile|
        page.should have_selector('li', text: profile.name)
      end
    end
    #it "should correctly nest each profile" do
    #  HmmProfile.all_parents.each do |profile|
    #    page.should have_selector('
  end

  describe "Showing a profile" do
    subject{ page }
    
    describe "With results" do
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      let!(:m1){ FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile) }
      let!(:m2){ FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile) }
      before {visit hmm_profile_path(hmm_profile) } 
      
      it { should have_selector('h1', text: hmm_profile.name) }
      it { should have_selector('title', text: full_title(hmm_profile.name)) }
      
      describe "Results" do
        subject { page }
        it { should have_content(hmm_profile.hmm_results.count) }
        it "should have the dates" do
          should have_content(m1.executed)
        end
      end
    end
  end
  describe "Show Page" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:sequence_db) { FactoryGirl.create(:sequence_db) }
    before do
      #@bulk_tblout = fixture_file_upload('/sample.tblout')
      visit hmm_profile_path(hmm_profile)
      select('ref', :from => 'hmm_result[sequence_db_id]')
      click_on 'Create Result'
    end
    it "should be able to create a new HmmResult " do
      page.should have_content('successfully')
    end
  end
end
