require 'spec_helper'

describe "hmm_score_criteria/show" do
  before(:each) do
    @hmm_score_criterion = assign(:hmm_score_criterion, stub_model(HmmScoreCriterion))
  end

  it "renders attributes in <p>" do
    render
  end
end
