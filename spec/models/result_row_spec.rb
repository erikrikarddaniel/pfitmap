require 'spec_helper'

describe ResultRow do
  let(:profile) { FactoryGirl.create(:profile) }
  let(:result) { FactoryGirl.create(:result, profile: profile) }
  
  before do 
      @resultrow = ResultRow.new(result_id: result.id) 
  end
  subject { @resultrow }
  describe "create valid result row" do
    
    it {should respond_to(:result_id) }
    its(:result) {should == result }
    it { should be_valid }
  end
  describe "without result_id" do
    before { @resultrow.result_id = nil }
    it {should_not be_valid }
  end
  describe "created from result" do
    before do
      @result_row_2 = result.result_rows.create!()
    end
    subject { @result_row_2}
    
    it { should be_valid }
    it { should respond_to(:result_id) }
    its(:result){ should_not be_nil }
    its(:result){ should == result }
  end
end
