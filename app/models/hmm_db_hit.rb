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
  has_many :hmm_result_rows, :through => :hmm_result_rows_hmm_db_hits
  has_many :hmm_result_rows_hmm_db_hits
  validates :gi, presence: true
end
