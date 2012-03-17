require 'spec_helper'

describe Profile do

  before { @profile = Profile.new(name: "Example Profile", parent_profile_id: "3") }

  subject { @profile }

  it { should respond_to(:name) }
  it { should respond_to(:parent_profile_id) }
  it { should be_valid }
  
  describe "When name is not present" do
    before { @profile.name = "" }
    it { should_not be_valid }
  end
end
