# == Schema Information
#
# Table name: db_sequence_best_profiles
#
#  db_sequence_id     :integer
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  hmm_result_row_id  :integer
#

class DbSequenceBestProfile < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :sequence_source
  belongs_to :db_sequence
  belongs_to :hmm_result_row

  def fullseq_score
    self.hmm_result_row.fullseq_score
  end
end
