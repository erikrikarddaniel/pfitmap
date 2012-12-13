# == Schema Information
#
# Table name: db_sequence_best_profiles
#
#  db_sequence_id     :integer
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  hmm_result_row_id  :integer
#  fullseq_score      :float
#

class DbSequenceBestProfile < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :sequence_source
  belongs_to :db_sequence
  belongs_to :hmm_result_row
  has_one :pfitmap_release, :through => :sequence_source



  def self.included_stats(hp,ss)
    release = ss.pfitmap_release
    stat = HmmProfileReleaseStatistic.stats_for(hp,ss,release)
  end

  def self.not_included_stats(hp,ss)
    stat = HmmProfileReleaseStatistic.stats_for(hp,ss,nil)
  end

  def self.include_profile?(db_sequence, sequence_source, hmm_profile)
    self.where("db_sequence_id = ? AND sequence_source_id = ? AND hmm_profile_id = ?", db_sequence.id, sequence_source.id, hmm_profile.id).exists?
  end
end
