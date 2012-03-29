require 'spec_helper'

describe "hmm_result_rows/index" do
  before(:each) do
    assign(:hmm_result_rows, [
      stub_model(HmmResultRow,
        :target_name => "Target Name",
        :target_acc => "Target Acc",
        :query_name => "Query Name",
        :query_acc => "Query Acc",
        :fullseq_evalue => 1.5,
        :fullseq_score => 1.5,
        :fullseq_bias => 1.5,
        :bestdom_evalue => 1.5,
        :bestdom_score => 1.5,
        :bestdom_bias => 1.5,
        :domnumest_exp => 1.5,
        :domnumest_reg => 1,
        :domnumest_clu => 1,
        :domnumest_ov => 1,
        :domnumest_env => 1,
        :domnumest_rep => 1,
        :domnumest_inc => 1
      ),
      stub_model(HmmResultRow,
        :target_name => "Target Name",
        :target_acc => "Target Acc",
        :query_name => "Query Name",
        :query_acc => "Query Acc",
        :fullseq_evalue => 1.5,
        :fullseq_score => 1.5,
        :fullseq_bias => 1.5,
        :bestdom_evalue => 1.5,
        :bestdom_score => 1.5,
        :bestdom_bias => 1.5,
        :domnumest_exp => 1.5,
        :domnumest_reg => 1,
        :domnumest_clu => 1,
        :domnumest_ov => 1,
        :domnumest_env => 1,
        :domnumest_rep => 1,
        :domnumest_inc => 1
      )
    ])
  end

  it "renders a list of hmm_result_rows" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Target Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Target Acc".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Query Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Query Acc".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
