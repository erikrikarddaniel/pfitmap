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

require 'spec_helper'

describe HmmScoreCriterion do
  pending "add some examples to (or delete) #{__FILE__}"
end
