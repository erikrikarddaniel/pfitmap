# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Protein < ActiveRecord::Base
  belongs_to :HmmProfile
  belongs_to :Enzyme
end
