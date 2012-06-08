# == Schema Information
#
# Table name: hmm_score_criterions
#
#  id                :integer         not null, primary key
#  min_fullseq_score :float
#  hmm_profile_id    :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class HmmScoreCriterion < InclusionCriterion
  attr_accessible :min_fullseq_score
  #has_one :inclusion_criterion, :as => :criteria
  validates :hmm_profile_id, :presence => :true, :uniqueness => :true
  validates :min_fullseq_score, :presence => :true

  #Assumes best hmm profile for db_sequence is the profile that 
  # inclusion criterion belongs to.
  def evaluate?(db_sequence)
    score = db_sequence.best_hmm_result_row.fullseq_score
    return (score > self.min_fullseq_score)
  end
end
