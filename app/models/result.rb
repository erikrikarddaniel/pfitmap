# == Schema Information
#
# Table name: results
#
#  id         :integer         not null, primary key
#  date       :date
#  profile_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Result < ActiveRecord::Base
  belongs_to :profile
end
