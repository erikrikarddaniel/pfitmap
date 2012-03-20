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
  #validates :seq, presence: true
end
