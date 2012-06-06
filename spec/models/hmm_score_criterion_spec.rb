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
  let!(:inclusion_criterion) { FactoryGirl.create(:inclusion_criterion) }
  before do
    @hmm_score_criterion = HmmScoreCriterion.new(inclusion_criterion_id: inclusion_criterion.id)
  end
  subject{ @hmm_score_criterion }
  
  it{ should be_valid }
  it{ should respond_to(:min_fullseq_score) }
  it{ should respond_to(:inclusion_criterion) }
  it{ should respond_to(:inclusion_criterion_id) }
  its(:inclusion_criterion) { should == inclusion_criterion }
  
  describe "without inclusion criterion" do
    before do
      @hmm_score_criterion.inclusion_criterion_id = nil
    end
    it{ should_not be_valid }
  end
end
