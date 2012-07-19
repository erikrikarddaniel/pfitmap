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
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile2, sequence_source: sequence_source) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence3) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence4) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_db_hit1) { FactoryGirl.create(:hmm_db_hit, gi: 104780528) }
    let!(:hmm_db_hit2) { FactoryGirl.create(:hmm_db_hit, gi: 95109515) }
    let!(:hmm_db_hit3) { FactoryGirl.create(:hmm_db_hit, gi: 107021672) }
    let!(:hmm_db_hit4) { FactoryGirl.create(:hmm_db_hit, gi: 116688618) }
    let!(:hmm_db_hit5) { FactoryGirl.create(:hmm_db_hit, gi: 170731917) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence1) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence2 ) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence3) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence4) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence1) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence2) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence3) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result2, db_sequence: db_sequence4) }
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
    
    before do
      make_mock_admin
      login_with_oauth
      visit sequence_source_path(sequence_source)
      click_on "Evaluate"
    end

    it "can calculate" do
      visit pfitmap_release_path(pfitmap_release)
      click_on "Calculate"
      page.should have_content "calculated successfully"
      visit protein_counts_path
      save_and_open_page
      visit proteins_path
      save_and_open_page
    end
  end
end
