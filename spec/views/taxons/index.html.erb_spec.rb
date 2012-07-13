require 'spec_helper'

describe "taxons/index" do
  before(:each) do
    assign(:taxons, [
      stub_model(Taxon,
        :name => "Name",
        :rank => "Rank",
        :wgs => false
      ),
      stub_model(Taxon,
        :name => "Name",
        :rank => "Rank",
        :wgs => false
      )
    ])
  end

  it "renders a list of taxons" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rank".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
