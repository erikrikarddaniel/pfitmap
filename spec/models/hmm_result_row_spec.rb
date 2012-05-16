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
#  domnumest_dom  :integer
#  db_sequence_id :integer
#

require 'spec_helper'

describe HmmResultRow do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:sequence_db) { FactoryGirl.create(:sequence_db) }
  let!(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }
  before do 
      @resultrow = HmmResultRow.new(hmm_result_id: result.id, db_sequence_id: db_sequence.id)
  end
  subject { @resultrow }
  
  it {should respond_to(:hmm_result_id) }
  it {should respond_to(:target_name) }
  it {should respond_to(:target_acc) }
  it {should respond_to(:query_name) }
  it {should respond_to(:query_acc) }
  it {should respond_to(:fullseq_evalue) }
  it {should respond_to(:fullseq_score) }
  it {should respond_to(:fullseq_bias) }
  it {should respond_to(:domnumest_exp) }
  it {should respond_to(:domnumest_reg) }
  it {should respond_to(:domnumest_clu) }
  it {should respond_to(:domnumest_ov) }
  it {should respond_to(:domnumest_env) }
  it {should respond_to(:domnumest_dom) }
  it {should respond_to(:domnumest_rep) }
  it {should respond_to(:domnumest_inc) }
  it {should respond_to(:db_sequence_id) }

  it {should_not respond_to(:db_sequences) }
  it {should respond_to(:db_sequence) }
  it {should respond_to(:hmm_db_hits) }
  it {should respond_to(:best_hit_evalue?) }
  it {should respond_to(:best_hit_score?) }
  it {should respond_to(:dbs_included) }

  its(:hmm_result) {should == result }
  it { should be_valid }
  
  describe "without hmm_result_id" do
    before { @resultrow.hmm_result_id = nil }
    it {should_not be_valid }
  end
  
  describe "created from result" do
    before do
      @result_row_2 = result.hmm_result_rows.create!(db_sequence_id: db_sequence.id)
    end
    subject { @result_row_2}
    
    it { should be_valid }
    it { should respond_to(:hmm_result_id) }
    its(:hmm_result){ should_not be_nil }
    its(:hmm_result){ should == result }
    its(:db_sequence) { should == db_sequence }
  end

  describe "association through DbSequence" do
    its(:hmm_db_hits) { should include(db_hit) }
  end

  describe "calculation of best hit" do
    before do
      @hmmp001 = FactoryGirl.create(:hmm_profile001)
      @hmmp00100 = FactoryGirl.create(:hmm_profile00100, parent: @hmmp001)
    end
  end

  describe "finding all unique databases represented in the hit list" do
    before do
      @resultrow = HmmResultRow.new(hmm_result_id: result.id)
    end
    its( :dbs_included ) { should include("ref") }
  end
end
