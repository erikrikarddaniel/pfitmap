require 'spec_helper'

describe "db_sequences/show" do
  before(:each) do
    @db_sequence = assign(:db_sequence, stub_model(DbSequence,
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
