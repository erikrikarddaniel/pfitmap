require 'spec_helper'

describe "PfitmapReleases" do
  describe "header functionality" do
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, current: true) }
    
    it "should display a chosen release on root page" do
      visit root_path
      page.should have_content("Release (#{pfitmap_release2.release})")
    end

    it "should be able to select release" do
      visit root_path
      click_on "Release (#{pfitmap_release2.release})"
      click_on "#{pfitmap_release1.release}"
      page.should have_content("Release (#{pfitmap_release1.release})")
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
