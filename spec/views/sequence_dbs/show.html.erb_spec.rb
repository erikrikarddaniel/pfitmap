require 'spec_helper'

describe "sequence_dbs/show" do
  before(:each) do
    @sequence_db = assign(:sequence_db, stub_model(SequenceDb,
      :source => "Source",
      :name => "Name",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Source/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
  end
end
