require 'spec_helper'

describe "hmm_score_criteria/index" do
  before(:each) do
    assign(:hmm_score_criteria, [
      stub_model(HmmScoreCriterion),
      stub_model(HmmScoreCriterion)
    ])
  end

  it "renders a list of hmm_score_criteria" do
    render
  end
end
