require 'spec_helper'

describe "hmm_result_rows/new" do
  before(:each) do
    assign(:hmm_result_row, stub_model(HmmResultRow,
      :target_name => "MyString",
      :target_acc => "MyString",
      :query_name => "MyString",
      :query_acc => "MyString",
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
    ).as_new_record)
  end

  it "renders new hmm_result_row form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_result_rows_path, :method => "post" do
      assert_select "input#hmm_result_row_target_name", :name => "hmm_result_row[target_name]"
      assert_select "input#hmm_result_row_target_acc", :name => "hmm_result_row[target_acc]"
      assert_select "input#hmm_result_row_query_name", :name => "hmm_result_row[query_name]"
      assert_select "input#hmm_result_row_query_acc", :name => "hmm_result_row[query_acc]"
      assert_select "input#hmm_result_row_fullseq_evalue", :name => "hmm_result_row[fullseq_evalue]"
      assert_select "input#hmm_result_row_fullseq_score", :name => "hmm_result_row[fullseq_score]"
      assert_select "input#hmm_result_row_fullseq_bias", :name => "hmm_result_row[fullseq_bias]"
      assert_select "input#hmm_result_row_bestdom_evalue", :name => "hmm_result_row[bestdom_evalue]"
      assert_select "input#hmm_result_row_bestdom_score", :name => "hmm_result_row[bestdom_score]"
      assert_select "input#hmm_result_row_bestdom_bias", :name => "hmm_result_row[bestdom_bias]"
      assert_select "input#hmm_result_row_domnumest_exp", :name => "hmm_result_row[domnumest_exp]"
      assert_select "input#hmm_result_row_domnumest_reg", :name => "hmm_result_row[domnumest_reg]"
      assert_select "input#hmm_result_row_domnumest_clu", :name => "hmm_result_row[domnumest_clu]"
      assert_select "input#hmm_result_row_domnumest_ov", :name => "hmm_result_row[domnumest_ov]"
      assert_select "input#hmm_result_row_domnumest_env", :name => "hmm_result_row[domnumest_env]"
      assert_select "input#hmm_result_row_domnumest_rep", :name => "hmm_result_row[domnumest_rep]"
      assert_select "input#hmm_result_row_domnumest_inc", :name => "hmm_result_row[domnumest_inc]"
    end
  end
end
