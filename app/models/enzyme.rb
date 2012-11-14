# == Schema Information
#
# Table name: enzymes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Enzyme < ActiveRecord::Base
  attr_accessible :name
  has_many :enzyme_profiles, dependent: :destroy
  has_many :hmm_profiles, through: :enzyme_profiles
  has_many :proteins, through: :hmm_profiles
  validates :name, :presence => :true
end
