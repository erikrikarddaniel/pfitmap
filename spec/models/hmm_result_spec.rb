# == Schema Information
#
# Table name: hmm_results
#
#  id             :integer         not null, primary key
#  executed       :datetime
#  sequence_db_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  hmm_profile_id :integer
#

require 'spec_helper'

describe HmmResult do
  let(:profile) { FactoryGirl.create(:hmm_profile) }
  let(:sequence_db) { FactoryGirl.create(:sequence_db) }
  before { @result = profile.hmm_results.build(executed: "20110318", sequence_db_id: sequence_db.id )}
  
  subject { @result }
  
  it { should respond_to(:executed) }
  it { should respond_to(:sequence_db_id) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:hmm_profile_id) }
  it { should respond_to(:hmm_profile) }
  its(:hmm_profile) { should == profile }
  
  it { should be_valid }
  
  describe "should not be valid when hmm profile_id is not present" do
    before { @result.hmm_profile_id = nil }
    it { should_not be_valid }
  end

  describe "should be valid after test" do
    it { should be_valid }
  end

  describe "should not be valid when sequence_db is not present" do
    before { @result.sequence_db_id = nil }
    it { should_not be_valid }
  end
end
