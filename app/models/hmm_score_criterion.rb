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

class HmmScoreCriterion < ActiveRecord::Base
  attr_accessible :min_fullseq_score, :hmm_profile_id
  belongs_to :hmm_profile
  validates :hmm_profile_id, :presence => :true, :uniqueness => :true
  validates :min_fullseq_score, :presence => :true

  #Assumes best hmm profile for db_sequence is the profile that 
  # inclusion criterion belongs to.
  def evaluate?(db_sequence)
    score = db_sequence.best_hmm_result_row.fullseq_score
    return (score > self.min_fullseq_score)
  end
end
