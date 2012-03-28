require 'spec_helper'

describe "sequence_dbs/edit" do
  before(:each) do
    @sequence_db = assign(:sequence_db, stub_model(SequenceDb,
      :source => "MyString",
      :name => "MyString",
      :version => "MyString"
    ))
  end

  it "renders the edit sequence_db form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sequence_dbs_path(@sequence_db), :method => "post" do
      assert_select "input#sequence_db_source", :name => "sequence_db[source]"
      assert_select "input#sequence_db_name", :name => "sequence_db[name]"
      assert_select "input#sequence_db_version", :name => "sequence_db[version]"
    end
  end
end
