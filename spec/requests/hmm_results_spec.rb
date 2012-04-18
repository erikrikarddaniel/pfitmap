require 'spec_helper'

describe "HmmResults" do
  subject { page }
  
  let!(:profile1) { FactoryGirl.create(:hmm_profile, name: "class 1" ) }
  let!(:profile2) { FactoryGirl.create(:hmm_profile, name: "class 2" ) }
  let!(:r1) { FactoryGirl.create(:hmm_result, hmm_profile: profile1, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: r1) }
  let!(:sequence) { FactoryGirl.create(:hmm_db_hit) }
  before do
    @relation = DbSequence.new(hmm_result_row_id: result_row.id, hmm_db_hit_id: sequence.id)
    @relation.save
  end

  describe "show result" do
    before{ visit hmm_result_path(r1) }
    it {should have_content(profile1.name ) }
    it {should have_content(r1.executed.year.to_s) }
    it {should have_content('Listing HMM result-rows') }
    
    it "should list each result row id" do
      r1.hmm_result_rows.each do |row|
        page.should have_content(row.id.to_s )
      end
    end
  end
  
  describe "show result-rows" do
    before do
      visit hmm_result_row_path(result_row)
    end
    it "should have the correct content" do
      page.should have_content(profile1.name)
      page.should have_content(result_row.fullseq_evalue)
      page.should have_content('Listing HMM database hits')
      page.should have_content(result_row.target_name)
      result_row.hmm_db_hits.each do |h|
        pending "List hmm db hits not finished"
        page.should have_content(h.acc)
        page.should have_content('Listing HMM database hits')
      end
    end
  end
end
