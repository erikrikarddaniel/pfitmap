# == Schema Information
#
# Table name: inclusion_criterions
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class InclusionCriterion < ActiveRecord::Base
  attr_accessible :hmm_profile_id
  belongs_to :hmm_profile
  has_one :hmm_score_criterion, :dependent => :destroy
  validates :hmm_profile_id, :presence => :true
end
