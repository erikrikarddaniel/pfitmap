# require 'spec_helper'

# describe "hmm_results/show" do
#   let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
#   let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
#   let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, sequence_source: sequence_source, executed: 100.years.ago) }
#   let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result) }
#   let!(:result_row2) { FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result) }

#   it "shows the result rows basic information" do
#     page.should have_content(hmm_result_row.fullseq_evalue.to_s)
#   end
# end
