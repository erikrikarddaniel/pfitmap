require 'spec_helper'

describe ResultRowsSequence do
  let(:profile) { FactoryGirl.create(:profile) }
  let(:result) { FactoryGirl.create(:result, profile: profile) }
  let(:result_row) { FactoryGirl.create(:resultRow, result: result) }
  let(:sequence) { FactoryGirl.create(:sequence) }

  describe "create valid relation" do
    before do
      profile.save
      result.save
      result_row.save
      sequence.save
      @relation = ResultRowsSequence.new(sequence_id: sequence.id, result_row_id: result_row.id)
    end
    
    subject { @relation }
    it { should respond_to(:sequence_id) }
    it { should respond_to(:result_row_id) }
    describe "related sequence and row" do
      before { @relation.save }
      its(:sequence) { should == sequence }
      its(:sequence) { should_not be_nil }
      its(:result_row) { should == result_row }
      its(:result_row) { should_not be_nil }
    end
    it { should be_valid }
    
    describe "invalid without sequence_id" do
      before {@relation.sequence_id = nil }
      
      subject { @relation }
      it { should_not be_valid}
    end
    describe "invalid without result_row_id" do
      before do
        @relation.sequence_id = sequence.id
        @relation.result_row_id = nil
      end
      it { should_not be_valid }
    end
  end
end
