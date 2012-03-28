require 'spec_helper'

describe "sequence_dbs/new" do
  before(:each) do
    assign(:sequence_db, stub_model(SequenceDb,
      :source => "MyString",
      :name => "MyString",
      :version => "MyString"
    ).as_new_record)
  end

  it "renders new sequence_db form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sequence_dbs_path, :method => "post" do
      assert_select "input#sequence_db_source", :name => "sequence_db[source]"
      assert_select "input#sequence_db_name", :name => "sequence_db[name]"
      assert_select "input#sequence_db_version", :name => "sequence_db[version]"
    end
  end
end
