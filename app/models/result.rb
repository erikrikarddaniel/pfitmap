# == Schema Information
#
# Table name: results
#
#  id         :integer         not null, primary key
#  date       :date
#  profile_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Result < ActiveRecord::Base
  belongs_to :profile
  has_many :sequences, through: :result_seq_relations
  belongs_to :result_seq_relations
  attr_accessible :date
  validates :profile_id, presence: true
  default_scope order: 'results.date DESC'
end
