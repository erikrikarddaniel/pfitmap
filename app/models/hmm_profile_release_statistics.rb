# == Schema Information
#
# Table name: hmm_profile_release_statistics
#
#  hmm_profile_id     :integer
#  sequence_source_id :integer
#  pfitmap_release_id :integer
#  count              :integer(8)
#  min                :float
#  max                :float
#

class HmmProfileReleaseStatistics < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :sequence_source
  belongs_to :pfitmap_release
end
