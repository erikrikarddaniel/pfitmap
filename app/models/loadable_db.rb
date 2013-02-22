# == Schema Information
#
# Table name: loadable_dbs
#
#  id               :integer         not null, primary key
#  db               :string(255)
#  common_name      :string(255)
#  genome_sequenced :boolean
#  default          :boolean
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class LoadableDb < ActiveRecord::Base
  attr_accessible :common_name, :db, :default, :genome_sequenced
  validates :db, presence: true, uniqueness: true
  validates :common_name, presence: true, uniqueness: true
  validates :genome_sequenced, :inclusion => {:in => [true, false]}
  validates :default, :inclusion => {:in => [true, false]}
  has_many :protein_counts
end
