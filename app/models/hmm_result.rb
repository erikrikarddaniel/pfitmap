# == Schema Information
#
# Table name: hmm_results
#
#  id             :integer         not null, primary key
#  executed       :datetime
#  sequence_db_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  hmm_profile_id :integer
#

class HmmResult < ActiveRecord::Base
  belongs_to :sequence_db
  belongs_to :hmm_profile
  validates :hmm_profile_id, presence: true
  validates :sequence_db_id, presence: true
end
