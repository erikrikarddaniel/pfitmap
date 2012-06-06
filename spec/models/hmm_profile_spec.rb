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
  let(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let(:hmm_profile_00101) { FactoryGirl.create(:hmm_profile_00101) }
  before do
    @hmm_profile = HmmProfile.create!(name: "Root HMM Profile", version: "20120328", hierarchy: "000")
  end

  subject { @hmm_profile }

  it { should respond_to(:name) }
  it { should respond_to(:version) }
  it { should respond_to(:hierarchy) }
  it { should respond_to(:parent_id) }
  it { should respond_to(:children) }
  it { should respond_to(:last_parent_id) }
  it { should be_valid }
  
  describe "Should not be valid when name is not present" do
    before { @hmm_profile.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @hmm_profile.version = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when hierarchy is not present" do
    before { @hmm_profile.hierarchy = "" }
    it { should_not be_valid }
  end

  describe "One should be able to create a child profile from a profile" do
    subject do
      @child = @hmm_profile.children.create(
	name: "1st gen. child HMM profile",
	version: "20120328",
	hierarchy: "000.00"
      )
    end
    it { should be_valid }
    it {  should respond_to(:name) }
  end

  describe "Profiles produced in the factory" do
    let(:hmm_profile_001) { FactoryGirl.create(:hmm_profile_001) }
    let(:hmm_profile_00100) { FactoryGirl.create(:hmm_profile_00100, parent: hmm_profile_001) }
    let(:hmm_profile_00101) { FactoryGirl.create(:hmm_profile_00101, parent: hmm_profile_001) }
    let(:hmm_profile_0010101){ FactoryGirl.create(:hmm_profile, parent: hmm_profile_00101) }
    
    it "should be able to find its last parent" do
      hmm_profile_0010101.last_parent_id.should == hmm_profile_001.id
    end
    
    it "should be able to list their closest children" do
      hmm_profile_001.children.should include(hmm_profile_00100)
    end
    
    it "should be able to list all last parents (root nodes)" do
      HmmProfile.last_parents().should include(hmm_profile_001)
    end
  end

  describe "inclusion criterion" do
    let!(:inclusion_criterion) { FactoryGirl.create(:inclusion_criterion, hmm_profile: @hmm_profile) }
    its(:inclusion_criterion) { should == inclusion_criterion }
  end
end
