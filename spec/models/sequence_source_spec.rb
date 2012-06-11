# == Schema Information
#
# Table name: sequence_sources
#
#  id         :integer         not null, primary key
#  source     :string(255)
#  name       :string(255)
#  version    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe SequenceSource do
  before(:each) do
    @attr = {
      :source => "NCBI",
      :name => "NR",
      :version => "20120328"
    }
    @seqdb = SequenceSource.new(@attr)
  end

  subject { @seqdb }

  it { should respond_to(:source) }
  it { should respond_to(:hmm_results) }
  it { should respond_to(:hmm_profiles) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:db_sequences) }
  it { should respond_to(:list_name) }
  it { should be_valid }

  describe "Should not be valid when source is not present" do
    before { @seqdb.source = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when name is not present" do
    before { @seqdb.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @seqdb.version = "" }
    it { should_not be_valid }
  end
  
  describe "associations" do
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_001) }
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence1) }
    subject{sequence_source}
    describe "all profiles available in results" do 
      its(:hmm_profiles) { should include(hmm_profile1) }
      its(:hmm_profiles) { should_not include(hmm_profile2) }
    end
    describe "all results" do
      its(:hmm_results) { should include(hmm_result1) }
    end
    
    describe "all result rows available in results" do
      its(:hmm_result_rows) { should include(hmm_result_row1) }
    end
    
    describe "all result rows available in results" do
      its(:db_sequences) { should include(db_sequence1) }
    end
  end

  describe "a correct list name" do
    its(:list_name) { should ==("NCBI:NR:20120328") }
  end
 
end
