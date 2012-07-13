require 'spec_helper'

describe "taxons/edit" do
  before(:each) do
    @taxon = assign(:taxon, stub_model(Taxon,
      :name => "MyString",
      :rank => "MyString",
      :wgs => false
    ))
  end

  it "renders the edit taxon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => taxons_path(@taxon), :method => "post" do
      assert_select "input#taxon_name", :name => "taxon[name]"
      assert_select "input#taxon_rank", :name => "taxon[rank]"
      assert_select "input#taxon_wgs", :name => "taxon[wgs]"
    end
  end
end
