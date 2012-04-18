require 'spec_helper'

describe "db_sequences/edit" do
  before(:each) do
    @db_sequence = assign(:db_sequence, stub_model(DbSequence,
      :hmm_result_row => nil,
      :hmm_db_hit => nil
    ))
  end

  it "renders the edit db_sequence form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => db_sequences_path(@db_sequence), :method => "post" do
      assert_select "input#db_sequence_hmm_result_row", :name => "db_sequence[hmm_result_row]"
      assert_select "input#db_sequence_hmm_db_hit", :name => "db_sequence[hmm_db_hit]"
    end
  end
end
