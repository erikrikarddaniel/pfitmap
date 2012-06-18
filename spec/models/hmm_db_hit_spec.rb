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

require 'spec_helper'

describe HmmDbHit do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:result) { FactoryGirl.create(:hmm_result, hmm_profile: profile) }
  let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: result, db_sequence: db_sequence) }
  let!(:db_hit) { FactoryGirl.create(:hmm_db_hit, db_sequence: db_sequence) }
  before do
    @db_hit2 = HmmDbHit.new(gi: "99999", db: "ref" , acc: "ex9999", desc: "Some name blabla", db_sequence_id: db_sequence.id)
  end

  subject { @db_hit2 }
  
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
    before {@db_hit2.gi= nil }
    it { should_not be_valid }
  end
  
  describe "when db sequence is not present" do
    before {@db_hit2.db_sequence = nil}
    it { should_not be_valid }
  end
  
  describe "with an added relation" do
    subject { db_hit }
    its(:hmm_result_rows) { should_not be_empty }
    its(:hmm_result_rows) { should include(result_row) }
    its(:db_sequence) { should == db_sequence }
  end
  
  describe "when adding duplicate combination of db and acc" do
    let!(:db_hit1) { FactoryGirl.create(:hmm_db_hit, db: "ref", acc: "ex9999") }
    it { should be_valid }
    it "should be saveable" do
      @db_hit2.save.should be_true
    end
  end

end
