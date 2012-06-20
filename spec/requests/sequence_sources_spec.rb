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
    
    it "should have an evaluate button" do
      page.should have_button("Evaluate")                           
    end
    describe "with results" do
      let!(:source1) { FactoryGirl.create(:sequence_source) }
      let!(:source2) { FactoryGirl.create(:sequence_source_older) }
      let!(:hmm_profile) { FactoryGirl.create(:hmm_profile_001) }
      let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_00100) }
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
      let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true) }
      before do
        visit sequence_source_path(sequence_source)
        click_button('Evaluate')
      end
      it "should give the release a db_sequence" do
        pfitmap_release.db_sequences.should include(db_sequence)
      end
      it "should be a success" do
        page.should have_content('successfully')
      end
    end
    
    describe "without existing current release" do
      let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: false) }
      before do
        visit sequence_source_path(sequence_source)
        click_on('Evaluate')
      end
      it "should not give the release a db_sequence" do
        pfitmap_release.db_sequences.should_not include(db_sequence)
      end
      
      it "should be an error" do
        page.should have_css('.alert-error')
      end
      
    end

  end
end
