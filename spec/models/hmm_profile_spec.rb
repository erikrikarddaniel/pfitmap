# == Schema Information
#
# Table name: hmm_profiles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  hierarchy  :string(255)
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe HmmProfile do

  before do
    @profile = HmmProfile.create!(name: "Root HMM Profile", version: "20120328", hierarchy: "000") 
  end

  subject { @profile }

  it { should respond_to(:name) }
  it { should respond_to(:version) }
  it { should respond_to(:hierarchy) }
  it { should respond_to(:parent_id) }
  it { should respond_to(:children) }
  it { should be_valid }
  
  describe "Should not be valid when name is not present" do
    before { @profile.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @profile.version = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when hierarchy is not present" do
    before { @profile.hierarchy = "" }
    it { should_not be_valid }
  end

  describe "One should be able to create a child profile from a profile" do
    subject do
      @child = @profile.children.create(
	name: "1st gen. child HMM profile",
	version: "20120328",
	hierarchy: "000.00"
      )
    end
    it { should be_valid }
  end
end
