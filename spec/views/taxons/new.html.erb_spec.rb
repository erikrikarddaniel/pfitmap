require 'spec_helper'

describe "taxons/new" do
  before(:each) do
    assign(:taxon, stub_model(Taxon,
      :name => "MyString",
      :rank => "MyString",
      :wgs => false
    ).as_new_record)
  end

  it "renders new taxon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => taxons_path, :method => "post" do
      assert_select "input#taxon_name", :name => "taxon[name]"
      assert_select "input#taxon_rank", :name => "taxon[rank]"
      assert_select "input#taxon_wgs", :name => "taxon[wgs]"
    end
  end
end
