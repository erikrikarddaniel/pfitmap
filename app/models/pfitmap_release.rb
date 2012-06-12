# == Schema Information
#
# Table name: pfitmap_releases
#
#  id           :integer         not null, primary key
#  release      :string(255)
#  release_date :date
#  current      :boolean
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#


class PfitmapRelease < ActiveRecord::Base
  attr_accessible :release, :release_date, :current
  has_many :pfitmap_sequences
  has_many :db_sequences, :through => :pfitmap_sequences
  validates :release, :presence => :true
  validates :release_date, :presence => :true
  validates_inclusion_of :current, :in => [true, false]
  validate :only_one_current

  # Should only be called when there exists a head release
  def self.add_seq_to_head(db_seq)
    head_release = PfitmapRelease.get_head_release
    if not head_release.db_sequences.find(db_seq.id)
      PfitmapSequence.create!(db_sequence: db_seq, pfitmap_release: head_release)
    end
  end
    
  def self.get_head_release
      return find_by_current(true)
  end

  private 
  def only_one_current
    current_release = PfitmapRelease.get_head_release
    if current_release
      if self.current
        self.errors[:base] << "There can only be one current release!"
      end
    end
  end
end
