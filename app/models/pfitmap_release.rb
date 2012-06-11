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
end
