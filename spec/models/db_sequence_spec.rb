# == Schema Information
#
# Table name: db_sequences
#
#  id          :integer         not null, primary key
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  aa_sequence :text
#

require 'spec_helper'

describe DbSequence do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_source: sequence_source, executed: 100.years.ago) }
  before do
    @db_sequence = DbSequence.new(aa_sequence: "LARS")
  end
  subject { @db_sequence }

  it { should respond_to(:id) }
  it { should_not respond_to(:hmm_result_row_id) }
  it { should_not respond_to(:hmm_db_hit_id) }
  it { should_not respond_to(:sequence ) }
  it { should respond_to(:aa_sequence) }
  it { should respond_to(:hmm_result_rows)}
  it { should respond_to(:hmm_db_hits) }

  it { should respond_to(:all_hits) }
  describe "with invalid parameters" do
    describe "without sequence" do
      before { @db_sequence.aa_sequence = nil }
      it {should_not be_valid }
    end
  end

  describe "with valid parameters" do
    it {should be_valid}
  end
  
  describe "should have a factory" do
    let(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    before do
      @hmm_db_hit = HmmDbHit.create(gi: "9999", db: "ref", acc: "ABCD", db_sequence_id: db_sequence.id)
    end
    subject{ @hmm_db_hit }
    it { should be_valid}
  end

  describe "listing all hits" do
    let(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    subject{db_sequence.all_hits(sequence_source)}
    it {should include(hmm_result_row)}
  end
end
