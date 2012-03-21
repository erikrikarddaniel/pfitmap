# == Schema Information
#
# Table name: result_seq_relations
#
#  id          :integer         not null, primary key
#  result_id   :integer
#  sequence_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe ResultSeqRelation do
  let(:profile) { FactoryGirl.create(:profile) }
  let(:result) { FactoryGirl.create(:result, profile: profile) }
  let(:sequence) { FactoryGirl.create(:sequence) }

  describe "create valid relation" do
    before do
      @relation = ResultSeqRelation.new(sequence_id: sequence.id, result_id: result.id)
    end
    
    subject { @relation }
    it { should respond_to(:sequence_id) }
    it { should respond_to(:result_id) }
    its(:sequence) { should == sequence }
    its(:result) { should == result }
    it { should be_valid }
    
    describe "invalid without sequence_id" do
      before {@relation.sequence_id = nil }
      
      subject { @relation }
      it { should_not be_valid}
    end
    describe "invalid without result_id" do
      before do
        @relation.sequence_id = sequence.id
        @relation.result_id = nil
      end
      it { should_not be_valid }
    end
  end
end
