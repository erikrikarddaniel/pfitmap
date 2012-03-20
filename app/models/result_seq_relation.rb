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
  belongs_to :sequence
  belongs_to :result
end
