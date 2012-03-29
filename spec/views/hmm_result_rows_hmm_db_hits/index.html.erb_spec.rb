require 'spec_helper'

describe "hmm_result_rows_hmm_db_hits/index" do
  before(:each) do
    assign(:hmm_result_rows_hmm_db_hits, [
      stub_model(HmmResultRowsHmmDbHit,
        :hmmResultRow => nil,
        :hmmDbHit => nil
      ),
      stub_model(HmmResultRowsHmmDbHit,
        :hmmResultRow => nil,
        :hmmDbHit => nil
      )
    ])
  end

  it "renders a list of hmm_result_rows_hmm_db_hits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
