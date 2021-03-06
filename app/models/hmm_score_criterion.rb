# == Schema Information
#
# Table name: hmm_score_criteria
#
#  id                :integer         not null, primary key
#  min_fullseq_score :float
#  hmm_profile_id    :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class HmmScoreCriterion < InclusionCriterion
  attr_accessible :min_fullseq_score
  validates :hmm_profile_id, :presence => :true, :uniqueness => :true
  validates :min_fullseq_score, :presence => :true

  #Assumes best hmm profile for db_sequence is the profile that 
  # inclusion criterion belongs to.
  def evaluate?(db_sequence, sequence_source)
    score = db_sequence.best_hmm_result_row(sequence_source).fullseq_score
    return (score > self.min_fullseq_score)
  end

  def evaluate_with_score?(db_sequence, sequence_source, fullseq_score)
    return (fullseq_score > self.min_fullseq_score)
  end
end
