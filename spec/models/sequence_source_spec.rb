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

  describe "it should list all profiles available in results" do 
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_001) }
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    subject{sequence_source}
    its(:hmm_profiles) { should include(hmm_profile1) }
    its(:hmm_profiles) { should_not include(hmm_profile2) }
  end

  describe "it should have a correct list name" do
    its(:list_name) { should ==("NCBI:NR:20120328") }
  end
end
