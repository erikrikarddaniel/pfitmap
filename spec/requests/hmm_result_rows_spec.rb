require 'spec_helper'

describe "HmmResultRows" do
  subject { page }
  let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
  let!(:profile2) { FactoryGirl.create(:hmm_profile, name: "class 2" ) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:r1) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, sequence_source: sequence_source, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1, db_sequence: db_sequence) }
  let!(:hmm_db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }

  describe "show result row" do 
    before{ visit hmm_result_row_path(result_row) }
    it {should have_content(profile1.name) }
  end
end
