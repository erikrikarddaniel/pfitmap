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
  has_and_belongs_to_many :result_rows
  validates :seq, presence: true
end
