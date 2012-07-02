# == Schema Information
#
# Table name: enzyme_profiles
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class EnzymeProfile < ActiveRecord::Base
  belongs_to :hmm_profile
  belongs_to :enzyme
end
