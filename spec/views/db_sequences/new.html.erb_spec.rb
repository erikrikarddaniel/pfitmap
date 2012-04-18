require 'spec_helper'

describe "db_sequences/new" do
  before(:each) do
    assign(:db_sequence, stub_model(DbSequence,
      :hmm_result_row => nil,
      :hmm_db_hit => nil
    ).as_new_record)
  end

  it "renders new db_sequence form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => db_sequences_path, :method => "post" do
      assert_select "input#db_sequence_hmm_result_row", :name => "db_sequence[hmm_result_row]"
      assert_select "input#db_sequence_hmm_db_hit", :name => "db_sequence[hmm_db_hit]"
    end
  end
end
