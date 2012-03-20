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

class Sequence < ActiveRecord::Base
  has_many :results, through: :result_seq_relations
  belongs_to :result_seq_relations
  validates :seq, presence: true
end
