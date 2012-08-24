require 'spec_helper'

describe "SequenceSources" do
  before do
    make_mock_admin
    login_with_oauth
  end
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }

  describe "index" do
    before{visit sequence_sources_path}
    it "displays atleast one source" do
      page.should have_content(sequence_source.name)
    end
  end

  describe "show" do
    before{visit sequence_source_path(sequence_source) }
 
    it "displays atleast the name" do
      page.should have_content(sequence_source.name)
    end

    context "whithout new release" do    
      it "should not have an evaluate button" do
        page.should have_content("There is no release connected to this source")
      end
    end
    
    describe "with results" do
      let!(:source1) { FactoryGirl.create(:sequence_source) }
      let!(:source2) { FactoryGirl.create(:sequence_source_older) }
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile_nrdbr2lox) }
      let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile, parent_id: hmm_profile.id) }
      # Results for profile 1
      let!(:r1){ FactoryGirl.create(:hmm_result, 
                                    hmm_profile: hmm_profile, 
                                    sequence_source: source1) }
      # Results for other profile, same sources
      let!(:r3){ FactoryGirl.create(:hmm_result, 
                                    hmm_profile: hmm_profile2, 
                                    sequence_source: source2) }
      describe "only one result" do
        before { visit sequence_source_path(source1) }
        subject { page }
        it "displays the correct result" do
          should have_content(r1.hmm_profile.name)
        end
        
        it "does not display results for other sources" do
          should_not have_tag('td', :text => r3.hmm_profile.name, :count => 1)
        end
      end
      
      describe "two results" do
        let!(:r2){ FactoryGirl.create(:hmm_result, 
                                      hmm_profile: hmm_profile2, 
                                      sequence_source: source1) }
        before { visit sequence_source_path(source1) }
        subject { page }
        it "displays the correct results" do
          should have_tag('td', :text => r1.hmm_profile.name, :count => 1)
          should have_tag('td', :text => r2.hmm_profile.name, :count => 1)
        end
        
        it "does not display results for other sources" do
          should_not have_tag('td', :text => r3.hmm_profile.name, :count => 2)
        end
        
      end
    end
  end

  describe "evaluating" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_score_criterion) { FactoryGirl.create(:hmm_score_criterion, 
                                                        hmm_profile: hmm_profile) }
    let!(:hmm_result) { FactoryGirl.create(:hmm_result,
                                           :sequence_source => sequence_source,
                                           :hmm_profile => hmm_profile) }
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, 
                                               :hmm_result => hmm_result,
                                               :db_sequence => db_sequence) }
    describe "with existing current release" do
      let!(:pfitmap_release_not_current) { FactoryGirl.create(:pfitmap_release) }
      let!(:pfitmap_release_current) { FactoryGirl.create(:pfitmap_release, current: true) }
      context "but without new release" do
        it "should not have an evaluate button" do
          visit sequence_source_path(sequence_source)
          page.should have_content("There is no release connected to this source")
        end
      end
      context "with a new release" do
        let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
        before do
          visit sequence_source_path(sequence_source)
          click_button('Evaluate')
        end
        
        it "should give the current release a db_sequence" do
          pfitmap_release.db_sequences.should include(db_sequence)
        end
        
        it "should not give other releases a db_sequence" do
          pfitmap_release_not_current.db_sequences.should == []
          pfitmap_release_current.db_sequences.should == []
        end
        
        it "should be a success" do
          page.should have_content('successfully')
        end
      end
    end

  end

  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end
    describe "new page" do
      before do
        visit new_sequence_source_path()
      end
      it "can handle invalid parameters" do
        click_button "Save Sequence Source"
        page.should have_content("The form contains 3 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Source', :with => "NCBI"
        page.fill_in 'Name', :with => "NR"
        page.fill_in 'Version', :with => "1988-06-13"
        click_button "Save Sequence Source"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
      before do
        visit edit_sequence_source_path(sequence_source)
      end
      it "can handle invalid parameters" do
        page.fill_in 'Source', :with => ""
        click_button "Save Sequence Source"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Source', :with => "NCBI2"
        click_button "Save Sequence Source"
        page.should have_content("successfully updated")
      end
    end
  end

end
