# == Schema Information
#
# Table name: sequence_sources
#
#  id         :integer         not null, primary key
#  source     :string(255)
#  name       :string(255)
#  version    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class SequenceSource < ActiveRecord::Base
  attr_protected :id, :created_at, :updated_at
  has_many :hmm_results
  has_many :hmm_profiles, :through => :hmm_results
  validates :source, presence: true
  validates :name, presence: true
  validates :version, presence: true
end
