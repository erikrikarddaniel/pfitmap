require 'spec_helper'

describe "hmm_score_criteria/edit" do
  before(:each) do
    @hmm_score_criterion = assign(:hmm_score_criterion, stub_model(HmmScoreCriterion))
  end

  it "renders the edit hmm_score_criterion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_score_criteria_path(@hmm_score_criterion), :method => "post" do
    end
  end
end
