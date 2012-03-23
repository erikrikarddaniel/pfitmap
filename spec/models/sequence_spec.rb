# == Schema Information
#
# Table name: sequences
#
#  id         :integer         not null, primary key
#  seq        :string(255)
#  biosql_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Sequence do
  let(:profile) { FactoryGirl.create(:profile) }
  let(:result) { FactoryGirl.create(:result, profile: profile) }
  let(:result_row) { FactoryGirl.create(:resultRow, result: result) }
  let(:sequence) { FactoryGirl.create(:sequence) }
  before do
    @sequence1 = Sequence.new(seq: "MSMAMAMTATAT", biosql_id: "5")
  end

  subject { @sequence1 }
  
  it { should respond_to(:seq) }
  it { should respond_to(:biosql_id) }
  it { should respond_to(:result_rows ) }
  it { should be_valid }

  describe "when sequence entry is not present" do
    before {@sequence1.seq= "" }
    it { should_not be_valid }
  end
  
  describe "with an added relation" do
    before do   
      @relation = ResultRowsSequence.new(sequence_id: sequence.id, result_row_id: result_row.id)
      @relation.save
    end

    subject { sequence }
    its(:result_rows_sequences) { should_not be_empty }
    its(:result_rows_sequences) { should include(@relation) }
    its(:result_rows) { should_not be_empty }
    its(:result_rows) { should include(result_row) }
  end
end
