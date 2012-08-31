# == Schema Information
#
# Table name: hmm_results
#
#  id                 :integer         not null, primary key
#  executed           :datetime
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  hmm_profile_id     :integer
#  sequence_source_id :integer         not null
#

require 'spec_helper'

describe HmmResult do
  let(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let(:sequence_source) { FactoryGirl.create(:sequence_source) }
  before { @result = hmm_profile.hmm_results.build(executed: "20110318", sequence_source_id: sequence_source.id )}
  
  subject { @result }
  
  it { should respond_to(:executed) }
  it { should respond_to(:sequence_source_id) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:hmm_profile_id) }
  it { should respond_to(:hmm_profile) }
  
  it { should be_valid }
  
  describe "should not be valid when hmm_profile_id is not present" do
    before { @result.hmm_profile_id = nil }
    it { should_not be_valid }
  end

  describe "should be valid after test" do
    it { should be_valid }
  end

  describe "should not be valid when sequence_source is not present" do
    before { @result.sequence_source_id = nil }
    it { should_not be_valid }
  end

  describe "should find its owner profile" do
    its(:hmm_profile) { should == hmm_profile }
  end

  describe "should have unique combination of profile and db" do
    before do
      @result.save!
      @result_bogus = hmm_profile.hmm_results.build(executed: "20110401", sequence_source_id: sequence_source.id) 
    end
    subject { @result_bogus }
    it { should_not be_valid }
  end
end
