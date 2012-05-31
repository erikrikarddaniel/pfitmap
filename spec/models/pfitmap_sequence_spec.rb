# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id             :integer         not null, primary key
#  db_sequence_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe PfitmapSequence do
  before do
    @pfitmap_sequence = PfitmapSequence.new()
  end
  subject{@pfitmap_sequence}
  it { should respond_to(:db_sequence) }
end