require 'spec_helper'

describe "hmm_result_rows_hmm_db_hits/new" do
  before(:each) do
    assign(:hmm_result_rows_hmm_db_hit, stub_model(HmmResultRowsHmmDbHit,
      :hmmResultRow => nil,
      :hmmDbHit => nil
    ).as_new_record)
  end

  it "renders new hmm_result_rows_hmm_db_hit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_result_rows_hmm_db_hits_path, :method => "post" do
      assert_select "input#hmm_result_rows_hmm_db_hit_hmmResultRow", :name => "hmm_result_rows_hmm_db_hit[hmmResultRow]"
      assert_select "input#hmm_result_rows_hmm_db_hit_hmmDbHit", :name => "hmm_result_rows_hmm_db_hit[hmmDbHit]"
    end
  end
end
