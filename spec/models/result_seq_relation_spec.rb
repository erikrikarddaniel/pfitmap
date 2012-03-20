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

  let(:result1) { FactoryGirl.create(:result) }
  let(:sequence1) { FactoryGirl.create(:sequence) }
  let(:result_seq_relation) do
    result1.result_seq_relations.build(sequence_id: sequence1.id)
  end

  subject { result_seq_relation }

  it { should be_valid }
end
