# == Schema Information
#
# Table name: profiles
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  parent_profile_id :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class Profile < ActiveRecord::Base
  belongs_to :profile
  has_many :profiles
  has_many :results

  validates :name, presence: true
end
