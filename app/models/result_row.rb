# == Schema Information
#
# Table name: result_rows
#
#  id         :integer         not null, primary key
#  result_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ResultRow < ActiveRecord::Base
  belongs_to :result
  has_and_belongs_to_many :sequences
  has_many :result_rows_sequences
  validates :result_id, presence: true
end
