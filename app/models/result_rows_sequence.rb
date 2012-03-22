
class ResultRowsSequence < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :result_row
  #attr_accessible :sequence_id, :result_ids
  validates :sequence_id, presence: :true
  validates :result_row_id, presence: :true
end
