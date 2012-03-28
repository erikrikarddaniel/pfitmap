require 'spec_helper'

describe "hmm_results/edit" do
  before(:each) do
    @hmm_result = assign(:hmm_result, stub_model(HmmResult,
      :result_db => nil
    ))
  end

  it "renders the edit hmm_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_results_path(@hmm_result), :method => "post" do
      assert_select "input#hmm_result_result_db", :name => "hmm_result[result_db]"
    end
  end
end
