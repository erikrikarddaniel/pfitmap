# == Schema Information
#
# Table name: inclusion_criterions
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class InclusionCriterion < ActiveRecord::Base
  attr_accessible :hmm_profile_id
  belongs_to :hmm_profile
  has_one :hmm_score_criterion, :dependent => :destroy
  validates :hmm_profile_id, :presence => :true, :uniqueness => :true

  # True if db_sequence actually belong to this profile, otherwise false. 
  def evaluate?(db_sequence)
    b1 = (db_sequence.best_hmm_profile == self.hmm_profile.id)
    b2= hmm_score_criterion.evaluate?(db_sequence)
    return b1 && b2
  end
end
