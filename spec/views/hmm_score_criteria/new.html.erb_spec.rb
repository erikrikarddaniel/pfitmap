require 'spec_helper'

describe "hmm_score_criteria/new" do
  before(:each) do
    assign(:hmm_score_criterion, stub_model(HmmScoreCriterion).as_new_record)
  end

  it "renders new hmm_score_criterion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_score_criteria_path, :method => "post" do
    end
  end
end
