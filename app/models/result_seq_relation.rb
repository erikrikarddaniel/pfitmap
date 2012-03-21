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

class ResultSeqRelation < ActiveRecord::Base
  attr_accessible :sequence_id, :result_id
  belongs_to :sequence
  belongs_to :result
  validates :sequence_id, presence: :true
  validates :result_id, presence: :true
end
