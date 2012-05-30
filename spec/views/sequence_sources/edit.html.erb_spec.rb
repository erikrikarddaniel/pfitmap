require 'spec_helper'

describe "sequence_sources/edit" do
  before(:each) do
    @sequence_source = assign(:sequence_source, stub_model(SequenceSource,
      :source => "MyString",
      :name => "MyString",
      :version => "MyString"
    ))
  end

  it "renders the edit sequence_source form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sequence_sources_path(@sequence_source), :method => "post" do
      assert_select "input#sequence_source_source", :name => "sequence_source[source]"
      assert_select "input#sequence_source_name", :name => "sequence_source[name]"
      assert_select "input#sequence_source_version", :name => "sequence_source[version]"
    end
  end
end
