# == Schema Information
#
# Table name: view_db_sequence_best_profiles
#
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  db_sequence_id     :integer
#  hmm_result_row_id  :integer
#  fullseq_score      :float
#

class ViewDbSequenceBestProfile < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :sequence_source
  belongs_to :db_sequence
  belongs_to :hmm_result_row
end
