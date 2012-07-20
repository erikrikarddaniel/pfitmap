require 'spec_helper'

describe "PfitmapReleases" do
  describe "header functionality" do
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release) }
    
    it "has no current release by default" do
      visit root_path
      page.should have_content("Release (No current release)")
    end

    it "has the select release" do
      visit root_path
      click_on "Release (No current release)"
      click_on "#{pfitmap_release1.release}"
      page.should have_content("Release (#{pfitmap_release1.release})")
    end
    
    describe "with current" do
      let!(:pfitmap_release3) { FactoryGirl.create(:pfitmap_release, current: true) }
      it "has current by default" do
        visit root_path
        page.should have_content("Release (#{pfitmap_release3.release})")
      end
      
      it "has the select release" do
        visit root_path
        click_on "Release (#{pfitmap_release3.release})"
        click_on "#{pfitmap_release1.release}"
        page.should have_content("Release (#{pfitmap_release1.release})")
      end
    end
  end

  describe "make current" do
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release) }
    
    context "as guest" do
      
      it "has no button" do
        visit pfitmap_release_path(pfitmap_release2)
        page.should_not have_content("Make this release current")
      end
    end

    context "as admin" do
      before do
        make_mock_admin
        login_with_oauth
      end
      
      it "button exists" do
        visit pfitmap_release_path(pfitmap_release2)
        page.should have_button("Make this release current")
      end

      it "button works" do
        visit pfitmap_releases_path
        page.should have_content("No current release")
        visit pfitmap_release_path(pfitmap_release2)
        click_on "Make this release current"
        page.should have_selector('b', text: "Release Number")
      end
    end
  end

  describe "show page" do
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release) }
    it "works for empty release" do
      visit pfitmap_release_path(pfitmap_release1)
      page.should have_content('Pfitmap Release')
    end
  end

  describe "Form page" do
    before do
      make_mock_admin
      login_with_oauth
    end
    describe "new page" do
      let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
      before do
        visit new_pfitmap_release_path()
      end
      it "can handle invalid parameters" do
        click_button "Create Pfitmap release"
        page.should have_content("The form contains 2 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Release', :with => "1.0"
        page.fill_in 'Release date', :with => "1988-06-13"
        page.select("#{sequence_source.list_name}")
        click_button "Create Pfitmap release"
        page.should have_content("successfully created")
      end
    end
      
    describe "edit page" do
      let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
      let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release) }
      before do
        visit edit_pfitmap_release_path(pfitmap_release)
      end
      it "can handle invalid parameters" do
        page.fill_in 'Release', :with => ""
        click_button "Update Pfitmap release"
        page.should have_content("The form contains 1 error")
      end
      
      it "can handle valid parameters" do
        page.fill_in 'Release', :with => "1.0"
        click_button "Update Pfitmap release"
        page.should have_content("successfully updated")
      end
    end
  end

  describe "evaluate and calculate" do
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile, protein_name: "ex1") }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile, protein_name: "ex2") }
    let!(:hmm_score_criterion1) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile1)}
    let!(:hmm_score_criterion2) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile2)}

    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile2, sequence_source: sequence_source) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence3) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence4) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence5) { FactoryGirl.create(:db_sequence) }
    
    let!(:hmm_db_hit1) { FactoryGirl.create(:hmm_db_hit, gi: 297089654, db_sequence: db_sequence1)}
    # Hit 2 and 3 are from the same species
    let!(:hmm_db_hit2) { FactoryGirl.create(:hmm_db_hit, gi: 297089694, db_sequence: db_sequence2)}
    let!(:hmm_db_hit3) { FactoryGirl.create(:hmm_db_hit, gi: 297089697, db_sequence: db_sequence3)}
    # Hit 4 and 5 are from the same species 
    let!(:hmm_db_hit4) { FactoryGirl.create(:hmm_db_hit, gi: 297089704, db_sequence: db_sequence4)}
    let!(:hmm_db_hit5) { FactoryGirl.create(:hmm_db_hit, gi: 297089710, db_sequence: db_sequence5)}
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence1) }
    let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence2 ) }
    let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence3) }
    let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence4) }
    let!(:hmm_result_row4) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence1) }
    let!(:hmm_result_row5) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence2) }
    let!(:hmm_result_row6) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence3) }
    let!(:hmm_result_row7) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence4) }
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
    
    before do
      make_mock_admin
      login_with_oauth
      visit sequence_source_path(sequence_source)
      click_on "Evaluate"
    end

    it "evaluated correclty" do
      pfitmap_release.hmm_db_hits.should include(hmm_db_hit1)
    end
    it "can calculate" do
      visit pfitmap_release_path(pfitmap_release)
      click_on "Calculate"
      page.should have_content "calculated successfully"
    end
  end

  describe "small test" do
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile, protein_name: "ex1") }
    let!(:hmm_score_criterion1) { FactoryGirl.create(:hmm_score_criterion, hmm_profile: hmm_profile1)}
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_db_hit1) { FactoryGirl.create(:hmm_db_hit, gi: 297089654, db_sequence: db_sequence1)}
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence1 ) }
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }



    before do
      make_mock_admin
      login_with_oauth
      visit sequence_source_path(sequence_source)
      click_on "Evaluate"
    end
    
#    it "can calculate" do
#      visit pfitmap_release_path(pfitmap_release)
#      click_on "Calculate"
#      page.should have_content "calculated successfully"
#    end
  end
  
end
