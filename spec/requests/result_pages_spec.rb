require 'spec_helper'

describe "ResultPages" do
  before do
    FactoryGirl.create(:profile, name: "class 1" )
    FactoryGirl.create(:profile, name: "class 2" )
  end
  let!(:r1) { FactoryGirl.create(:result, date: 1.day.ago) }
  
  subject { page }

  describe "GET /result_pages" do
    before{ visit result_path(r1) }
    it {should have_selector('h1', text: profile.name ) }
    it {should have_selector('h2', text: r1.date.year) }
  end
end

