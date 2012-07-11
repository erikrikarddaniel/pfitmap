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
end
