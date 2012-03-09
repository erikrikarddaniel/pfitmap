class Profile < ActiveRecord::Base
  belongs_to :profile
  has_many :profiles
  has_many :results
end
