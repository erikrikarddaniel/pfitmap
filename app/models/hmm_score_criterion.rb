# == Schema Information
#
# Table name: hmm_score_criterions
#
#  id                     :integer         not null, primary key
#  min_fullseq_score      :float
#  inclusion_criterion_id :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class HmmScoreCriterion < ActiveRecord::Base
  attr_accessible :min_fullseq_score, :inclusion_criterion_id
  belongs_to :inclusion_criterion
  validates :inclusion_criterion, :presence => :true
end
