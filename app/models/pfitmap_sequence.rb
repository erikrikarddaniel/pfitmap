# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id             :integer         not null, primary key
#  db_sequence_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class PfitmapSequence < ActiveRecord::Base
  belongs_to :db_sequence
end
