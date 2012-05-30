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
  let(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }
  let(:hmmp001) { FactoryGirl.create(:hmm_profile_001) }
  let(:hmmp00100) { FactoryGirl.create(:hmm_profile_00100, parent: hmmp001) }
  let!(:result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmmp001, sequence_source: sequence_source) }
  let!(:result2) { FactoryGirl.create(:hmm_result, hmm_profile: hmmp00100, sequence_source: sequence_source) }
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
      @row1  = HmmResultRow.create(hmm_result: result1, fullseq_evalue: 1, fullseq_score: 2, db_sequence: db_sequence)
      @row2  = HmmResultRow.create(hmm_result: result2, fullseq_evalue: 2, fullseq_score: 1, db_sequence: db_sequence)
    end
    it "recognizes the smallest evalue as the best hit" do
      @row1.best_hit_evalue?.should eq(true)
    end

    it "doesn't recognizes the non-smallest evalue as the best hit" do
      @row2.best_hit_evalue?.should eq(false)
    end

    it "recognizes the largest score as the best hit" do
      @row1.best_hit_score?.should eq(true)
    end
    
    it "does not recognizes the non-largest score as the best hit" do
      @row2.best_hit_score?.should eq(false)
    end
  end


  

  describe "finding all unique databases represented in the hit list" do
    its( :dbs_included ) { should eq(["ref"]) }
  end
end
