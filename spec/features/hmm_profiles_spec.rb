require 'spec_helper'

describe "Hmm Profile Pages" do
  before do
    make_mock_admin
    login_with_oauth
  end
    
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
    it "should correctly nest each profile" do
      HmmProfile.last_parents.each do |profile|
        page.should have_content("#{profile.name}")
      end
    end
  end

  describe "Showing a profile" do
    let!(:source1) { FactoryGirl.create(:sequence_source) }
    let!(:source2) { FactoryGirl.create(:sequence_source_older) }
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile, parent_id: hmm_profile.id) }
    # Results for profile 1
    let!(:r1){ FactoryGirl.create(:hmm_result, 
                                  hmm_profile: hmm_profile, 
                                  sequence_source: source1) }
    # Results for other profile, same sources
    let!(:r3){ FactoryGirl.create(:hmm_result, 
                                  hmm_profile: hmm_profile2, 
                                  sequence_source: source1) }
    let!(:r4){ FactoryGirl.create(:hmm_result, 
                                  hmm_profile: hmm_profile2, 
                                  sequence_source: source2) }
    

    before do
      visit hmm_profile_path(hmm_profile)
    end
    
    subject{ page }
    
    it { should have_selector('h1', text: hmm_profile.name) }
    it { should have_selector('title', text: full_title(hmm_profile.name)) }
    
    it { should have_content(hmm_profile.hmm_results.count) }
    it "displays one result" do
      # 1 + 1 = 2 rows
      should have_tag('tr', :count => 2)
    end

    it "displays the correct result" do
      should have_content(r1.sequence_source.version)
    end

  end

  describe "Register new result" do
    describe "with invalid parameters" do
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
      before do
        visit hmm_profile_path(hmm_profile)
      end
      
      describe "without a file" do
        describe "for an unoccupied source" do 
          it "cannot register new HmmResult " do
            expect{
              select(sequence_source.list_name, :from => 'hmm_result[sequence_source_id]')
              click_on 'Create Result'
            }.not_to change(HmmResult, :count)
            page.should have_content('No file given')
          end
        end
        
        describe "for an occupied source" do
          let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_source: sequence_source) }
          it "cannot register new HmmResult" do
            expect{
              select(sequence_source.list_name, :from => 'hmm_result[sequence_source_id]')
              click_on 'Create Result'
            }.not_to change(HmmResult, :count)
            page.should have_content('No file given')
          end
        end
      end
    end
    
    describe "with valid parameters" do
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
      it "should be able to create a new HmmResult" do
        # @bulk_tblout = fixture_file_upload('/sample.tblout')
        visit hmm_profile_path(hmm_profile)
        select(sequence_source.list_name, :from => 'hmm_result[sequence_source_id]')
        attach_file 'file', "#{Rails.root}/spec/fixtures/sample.tblout"
        click_on 'Create Result'
        page.should have_content('successfully')
      end
    
      it "is not possible through browser for non-admins" do
        visit signout_path
        visit hmm_profile_path(hmm_profile)
        
        page.should_not have_content('Create Result')
      end
    end
  end

  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end

    describe "new page" do
      let!(:hmm_profile_parent) { FactoryGirl.create(:hmm_profile) }
      before do
        visit new_hmm_profile_path()
      end
      it "can handle invalid parameters" do
        click_button "Create Profile"
        page.should have_content("The form contains 3 errors")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Name', :with => "Bobs' enzyme"
        page.fill_in 'Protein name', :with => "Bobs' Protein"
        page.fill_in 'Version', :with => "20120711"
        page.select("#{hmm_profile_parent.name}")
        click_button "Create Profile"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
      before do
        visit edit_hmm_profile_path(hmm_profile)
      end
      it "can handle invalid parameters" do
        page.fill_in 'Name', :with => ""
        click_button "Create Profile"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Name', :with => "Bobs' Profile"
        click_button "Create Profile"
        page.should have_content("successfully updated")
      end
    end
  end
end
