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

  describe "GET /pfitmap_releases" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pfitmap_releases_path
      response.status.should be(200)
    end
  end
end
