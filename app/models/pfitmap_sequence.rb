# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id                 :integer         not null, primary key
#  db_sequence_id     :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  pfitmap_release_id :integer
#  hmm_profile_id     :integer
#

class PfitmapSequence < ActiveRecord::Base
  attr_accessible :db_sequence_id, :pfitmap_release_id, :hmm_profile_id
  belongs_to :db_sequence
  belongs_to :pfitmap_release
  belongs_to :hmm_profile
  has_one :sequence_source, :through => :pfitmap_release
end
