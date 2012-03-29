require 'spec_helper'

describe "hmm_result_rows_hmm_db_hits/show" do
  before(:each) do
    @hmm_result_rows_hmm_db_hit = assign(:hmm_result_rows_hmm_db_hit, stub_model(HmmResultRowsHmmDbHit,
      :hmm_result_row => nil,
      :hmm_db_hit => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
