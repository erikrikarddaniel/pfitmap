require 'spec_helper'

describe "sequence_dbs/index" do
  before(:each) do
    assign(:sequence_dbs, [
      stub_model(SequenceDb,
        :source => "Source",
        :name => "Name",
        :version => "Version"
      ),
      stub_model(SequenceDb,
        :source => "Source",
        :name => "Name",
        :version => "Version"
      )
    ])
  end

  it "renders a list of sequence_dbs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
  end
end
