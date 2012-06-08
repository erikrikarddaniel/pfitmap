# == Schema Information
#
# Table name: inclusion_criterions
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

#Abstract class that different inclusion criteria inherit from
class InclusionCriterion < ActiveRecord::Base
  self.abstract_class = true
  attr_accessible :hmm_profile_id
  belongs_to :hmm_profile

  def evaluate?(db_sequence)
    raise NotImplementedError
  end
end
