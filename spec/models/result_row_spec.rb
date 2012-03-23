require 'spec_helper'

describe ResultRow do
  let(:profile) { FactoryGirl.create(:profile) }
  let(:result) { FactoryGirl.create(:result, profile: profile) }
  let(:sequence) { FactoryGirl.create(:sequence) }
  let(:result_row) { FactoryGirl.create(:resultRow, result: result) }
  before do 
      @resultrow = ResultRow.new(result_id: result.id) 
  end
  subject { @resultrow }
  
  it {should respond_to(:result_id) }
  its(:result) {should == result }
  it { should be_valid }
  
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
  describe "with a sequence association" do
    before do
      @relation = ResultRowsSequence.new(sequence_id: sequence.id, result_row_id: result_row.id)
      @relation.save
    end
    subject{ result_row }
    its( :result_rows_sequences ) { should_not be_empty }
    its( :result_rows_sequences ) { should include(@relation) }
    its( :sequences) { should_not be_empty }
    its( :sequences) { should include(sequence) }
  end
end
