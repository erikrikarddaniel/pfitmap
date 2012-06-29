# == Schema Information
#
# Table name: pfitmap_releases
#
#  id           :integer         not null, primary key
#  release      :string(255)
#  release_date :date
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#


class PfitmapRelease < ActiveRecord::Base
  attr_accessible :release, :release_date
  has_many :pfitmap_sequences
  has_many :db_sequences, :through => :pfitmap_sequences
  validates :release, :presence => :true
  validates :release_date, :presence => :true


  # Should only be called when there exists a head release
  def add_seq(db_seq)
    if not self.db_sequences.find_by_id(db_seq.id)
      PfitmapSequence.create!(db_sequence_id: db_seq.id, pfitmap_release_id: self.id)
    end
  end
    
  def self.find_current_release
      return first(:order => "release DESC")
  end
end
