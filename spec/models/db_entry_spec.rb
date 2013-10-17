# == Schema Information
#
# Table name: hmm_db_hits
#
#  id             :integer         not null, primary key
#  gi             :integer
#  db             :string(255)
#  acc            :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  db_sequence_id :integer
#  desc           :text
#
# ========================================================================
# !!!!!TODO Note that this test was generated for table named HmmDBHit but
# has been altered since that table will be renamed to DBEntry.
# Go over the test and change references to HmmDBHit when renaming is done
# ========================================================================

require 'spec_helper'

describe DbEntry do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: result, db_sequence: db_sequence) }
  let!(:db_entry) { FactoryGirl.create(:db_entry, db_sequence: db_sequence) }
  before do
    @db_entry2 = DbEntry.new(gi: "99999", db: "ref" , acc: "ex9999", desc: "Some name blabla", db_sequence_id: db_sequence.id)
  end

  subject { @db_entry2 }
  
  it { should respond_to(:gi) }
  it { should respond_to(:db) }
  it { should respond_to(:acc ) }
  it { should respond_to(:desc) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:db_sequence) }
  it { should_not respond_to(:db_sequences) }

  describe "with valid parameters" do
    it { should be_valid }
  end
  
  describe "when gi is not present" do
    before {@db_entry2.gi= nil }
    it { should_not be_valid }
  end
  
  describe "when db sequence is not present" do
    before {@db_entry2.db_sequence = nil}
    it { should_not be_valid }
  end
  
  describe "with an added relation" do
    subject { db_entry }
    its(:hmm_result_rows) { should_not be_empty }
    its(:hmm_result_rows) { should include(result_row) }
    its(:db_sequence) { should == db_sequence }
  end
  
  describe "when adding duplicate combination of db and acc" do
    let!(:db_entry1) { FactoryGirl.create(:db_entry, db: "ref", acc: "ex9999") }
    it { should be_valid }
    it "should be saveable" do
      @db_entry2.save.should be_true
    end
  end
end
