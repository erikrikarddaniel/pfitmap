# == Schema Information
#
# Table name: db_sequences
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  sequence   :text
#

require 'spec_helper'

describe DbSequence do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let!(:sequence_db) { FactoryGirl.create(:sequence_db) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_db: sequence_db, executed: 100.years.ago) }
  let!(:result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result) }
  let!(:hmm_db_hit) { FactoryGirl.create(:hmm_db_hit) }
  before do
    @db_sequence = DbSequence.new(hmm_result_row_id: result_row.id, hmm_db_hit_id: hmm_db_hit.id, sequence: "LARS")
  end
  subject { @db_sequence }

  it { should respond_to(:id) }
  it { should_not respond_to(:hmm_result_row_id) }
  it { should_not respond_to(:hmm_db_hit_id) }
  it { should respond_to(:sequence ) }
  it { should respond_to(:hmm_result_rows)}
  it { should respond_to(:hmm_db_hits) }

  it { should respond_to(:all_hits) }
  describe "with invalid parameters" do
    describe "without sequence" do
      before { @db_sequence.sequence = nil }
      it {should_not be_valid }
    end
  end

  describe "with valid parameters" do
    it {should be_valid}
  end
  
  describe "listing all hits" do
    subject{@db_sequence.all_hits(sequence_db)}
    it {should include(result_row)}
  end
end
