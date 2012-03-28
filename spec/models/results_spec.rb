require 'spec_helper'

describe Result do

  let(:profile) { FactoryGirl.create(:profile) }
  before { @result = profile.results.build(date: "20110318")}

  subject { @result }

  it { should respond_to(:date) }
  it { should respond_to(:profile_id) }
  it { should respond_to(:profile) }
  it { should respond_to(:result_seq_relation) }
  it { should respond_to(:result_rows) }
  its(:profile) { should == profile }
  
  it { should be_valid }

  describe "when profile_id is not present" do
    before { @result.profile_id = nil }
    it { should_not be_valid }
  end
end
