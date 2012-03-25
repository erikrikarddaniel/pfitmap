require 'spec_helper'

describe "ResultPages" do
  let(:profile1) {  FactoryGirl.create(:profile, name: "class 1" ) }
  let(:profile2) { FactoryGirl.create(:profile, name: "class 2" ) }
  let!(:r1) { FactoryGirl.create(:result, profile: profile1, date: 1.day.ago) }
  
  subject { page }

  describe "show result" do
    before{ visit result_path(r1) }
    it {should have_selector('h1', text: profile1.name ) }
    it {should have_selector('h2', text: r1.date.year.to_s) }
    it {should have_selector('h3', text: 'Listing result-row ids') }
    
    it "should list each result row id" do
      r1.result_rows.each do |row|
        page.should have_selector('li', text: row.id )
      end
    end
  end
end

