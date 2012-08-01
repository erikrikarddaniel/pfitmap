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
    [included(hp,ss).count, 
     included(hp,ss).minimum(:fullseq_score), 
     included(hp,ss).maximum(:fullseq_score)]
  end

  def self.not_included_stats(hp,ss)
    [not_included(hp,ss).count, 
     not_included(hp,ss).minimum(:fullseq_score), 
     not_included(hp,ss).maximum(:fullseq_score)]
  end

  def self.included(hmm_profile,sequence_source)
    release = sequence_source.pfitmap_release
    if release
      joins("JOIN pfitmap_sequences ON (pfitmap_sequences.db_sequence_id = db_sequence_best_profiles.db_sequence_id AND pfitmap_sequences.hmm_profile_id = db_sequence_best_profiles.hmm_profile_id)").where("db_sequence_best_profiles.hmm_profile_id = ? AND db_sequence_best_profiles.sequence_source_id = ? AND pfitmap_sequences.pfitmap_release_id = ?", hmm_profile.id, sequence_source.id, release.id)
    else
      nil
    end
  end

  def self.not_included(hmm_profile, sequence_source)
    release = sequence_source.pfitmap_release
    if release
      where("hmm_profile_id = ? AND sequence_source_id = ? AND db_sequence_id NOT IN (SELECT ps.db_sequence_id FROM pfitmap_sequences ps WHERE (ps.pfitmap_release_id = ? AND ps.hmm_profile_id = ?))", hmm_profile.id, sequence_source.id, release.id, hmm_profile.id)
    else
      nil
    end
  end
end
