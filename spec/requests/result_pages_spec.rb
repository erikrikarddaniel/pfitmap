# require 'spec_helper'

# describe "Result Pages" do
#   subject { page }
  
#   let!(:profile1) { FactoryGirl.create(:profile, name: "class 1" ) }
#   let!(:profile2) { FactoryGirl.create(:profile, name: "class 2" ) }
#   let!(:r1) { FactoryGirl.create(:result, profile: profile1, date: 1.day.ago) }
#   let!(:result_row) { FactoryGirl.create(:resultRow, result: r1) }
#   let!(:sequence) { FactoryGirl.create(:sequence) }
#   before do
#     @relation = ResultRowsSequence.new(result_row_id: result_row.id, sequence_id: sequence.id)
#     @relation.save
#   end

#   describe "show result" do
#     before{ visit result_path(r1) }
#     it {should have_selector('h1', text: profile1.name ) }
#     it {should have_selector('h2', text: r1.date.year.to_s) }
#     it {should have_selector('h3', text: 'Listing result-rows') }
    
#     it "should list each result row id" do
#       r1.result_rows.each do |row|
#         page.should have_selector('li', text: row.id.to_s )
#       end
#     end
#   end
  
#   describe "show result-rows" do
#     before do
#       visit result_row_path(result_row)
#     end
#     it "should have the correct content" do
#       page.should have_content(profile1.name)
#       page.should have_selector('h2', text: r1.date.year.to_s)
#       page.should have_content('Listing sequences')
#       page.should have_content(result_row.id)
#       result_row.sequences.each do |seq|
#         page.should have_selector('li', text: seq.seq[0,5] )
#         page.should have_content('Listing sequences')
#       end
#     end
#   end
# end
