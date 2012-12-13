# == Schema Information
#
# Table name: hmm_profile_release_statistics
#
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  pfitmap_release_id :integer
#  n                  :integer(8)
#  min_fullseq_score  :float
#  max_fullseq_score  :float
#

class HmmProfileReleaseStatistic < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :sequence_source
  belongs_to :pfitmap_release

  def self.stats_for(hp,ss,release)
    if release
      stat = where(["hmm_profile_id = ? AND sequence_source_id = ? AND pfitmap_release_id = ?", hp.id, ss.id, release.id]).first
    else
      stat = where(["hmm_profile_id = ? AND sequence_source_id = ? AND pfitmap_release_id IS NULL", hp.id, ss.id]).first
    end
    if stat
      [stat.n, 
       stat.min_fullseq_score,
       stat.max_fullseq_score]
    else
      [0,nil,nil]
    end
  end
end
