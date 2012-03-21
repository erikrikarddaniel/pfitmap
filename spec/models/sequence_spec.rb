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
  before { @sequence1 = Sequence.new(seq: "MSMAMAMTATAT", biosql_id: "5") }

  subject { @sequence1 }
  
  it { should respond_to(:seq) }
  it { should respond_to(:biosql_id) }
  it { should be_valid }
  
  describe "when sequence entry is not present" do
    before {@sequence1.seq= "" }
    it { should_not be_valid }
  end
  
end
