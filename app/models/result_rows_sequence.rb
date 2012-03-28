# == Schema Information
#
# Table name: result_rows_sequences
#
#  id            :integer         not null, primary key
#  result_row_id :integer         not null
#  sequence_id   :integer         not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#


class ResultRowsSequence < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :result_row
  #attr_accessible :sequence_id, :result_ids
  validates :sequence_id, presence: :true
  validates :result_row_id, presence: :true
end
