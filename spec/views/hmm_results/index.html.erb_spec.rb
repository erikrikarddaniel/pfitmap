require 'spec_helper'

describe "hmm_results/index" do
  before(:each) do
    assign(:hmm_results, [
      stub_model(HmmResult,
        :result_db => nil
      ),
      stub_model(HmmResult,
        :result_db => nil
      )
    ])
  end

  it "renders a list of hmm_results" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
