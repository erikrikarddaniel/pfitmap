# == Schema Information
#
# Table name: sequence_dbs
#
#  id         :integer         not null, primary key
#  source     :string(255)
#  name       :string(255)
#  version    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe SequenceDb do
  before(:each) do
    @attr = {
      :source => "NCBI",
      :name => "ref",
      :version => "20120328"
    }
    @seqdb = SequenceDb.new(@attr)
  end

  subject { @seqdb }

  it { should respond_to(:source) }
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
end
