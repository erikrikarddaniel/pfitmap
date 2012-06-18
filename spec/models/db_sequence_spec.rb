# == Schema Information
#
# Table name: db_sequences
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe DbSequence do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile_001) }
  let!(:hmm_profile_00100) { FactoryGirl.create(:hmm_profile_00100) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_source: sequence_source, executed: 100.years.ago) }
  before do
    @db_sequence = DbSequence.new()
  end
  subject { @db_sequence }

  it { should respond_to(:id) }
  it { should_not respond_to(:hmm_result_row_id) }
  it { should_not respond_to(:hmm_db_hit_id) }
  it { should respond_to(:hmm_result_rows)}
  it { should respond_to(:hmm_db_hits) }
  it { should_not respond_to(:pfitmap_sequence) }
  it { should respond_to(:pfitmap_sequences) }

  #Operations
  it { should respond_to(:all_hits) }
  it { should respond_to(:best_hmm_profile) }

  describe "with valid parameters" do
    it {should be_valid}
  end
  
  describe "create with factory" do
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

  describe "best hmm profile" do
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile_00100, sequence_source: sequence_source, executed: 100.years.ago) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    #Create a second result row with lower score
    let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result2, db_sequence: db_sequence) }
    subject { db_sequence}
    its(:best_hmm_profile) { should eq(hmm_profile.id) }
    its(:best_hmm_profile) { should_not eq(hmm_profile_00100.id) }
  end

  describe "pfitmap sequence" do
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    subject{db_sequence}
    describe "can be null" do
      its(:pfitmap_sequences) { should == [] }
    end
    describe "can be correct" do
      let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence) }
      its(:pfitmap_sequences) { should include(pfitmap_sequence) }
    end
  end
end
