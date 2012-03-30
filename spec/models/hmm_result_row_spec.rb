# == Schema Information
#
# Table name: hmm_result_rows
#
#  id             :integer         not null, primary key
#  target_name    :string(255)
#  target_acc     :string(255)
#  query_name     :string(255)
#  query_acc      :string(255)
#  fullseq_evalue :float
#  fullseq_score  :float
#  fullseq_bias   :float
#  bestdom_evalue :float
#  bestdom_score  :float
#  bestdom_bias   :float
#  domnumest_exp  :float
#  domnumest_reg  :integer
#  domnumest_clu  :integer
#  domnumest_ov   :integer
#  domnumest_env  :integer
#  domnumest_rep  :integer
#  domnumest_inc  :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  hmm_result_id  :integer
#

require 'spec_helper'

describe HmmResultRow do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:sequence_db) { FactoryGirl.create(:sequence_db) }
  let(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let(:db_hit) { FactoryGirl.create(:hmm_db_hit) }
  let(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: result) }
  before do 
      @resultrow = HmmResultRow.new(hmm_result_id: result.id)
  end
  subject { @resultrow }
  
  it {should respond_to(:hmm_result_id) }
  its(:hmm_result) {should == result }
  it { should be_valid }
  
  describe "without hmm_result_id" do
    before { @resultrow.hmm_result_id = nil }
    it {should_not be_valid }
  end
  
  describe "should validate something else" do
    pending "some other attribute that always should be present"
  end
  describe "created from result" do
    before do
      @result_row_2 = result.hmm_result_rows.create!()
    end
    subject { @result_row_2}
    
    it { should be_valid }
    it { should respond_to(:hmm_result_id) }
    its(:hmm_result){ should_not be_nil }
    its(:hmm_result){ should == result }
  end

  describe "with a sequence association" do
    before do
      @relation = HmmResultRowsHmmDbHit.new(hmm_db_hit_id: db_hit.id, hmm_result_row_id: result_row.id)
      @relation.save
    end
    subject{ result_row }
    its( :hmm_result_rows_hmm_db_hits ) { should_not be_empty }
    its( :hmm_result_rows_hmm_db_hits ) { should include(@relation) }
    its( :hmm_db_hits) { should_not be_empty }
    its( :hmm_db_hits) { should include(db_hit) }
  end
end
