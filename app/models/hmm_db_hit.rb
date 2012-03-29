# == Schema Information
#
# Table name: hmm_db_hits
#
#  id         :integer         not null, primary key
#  gi         :integer
#  db         :string(255)
#  acc        :string(255)
#  desc       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class HmmDbHit < ActiveRecord::Base
  has_and_belongs_to_many :hmm_result_rows
  validates :gi, presence: true
end
