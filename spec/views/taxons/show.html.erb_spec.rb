require 'spec_helper'

describe "taxons/show" do
  before(:each) do
    @taxon = assign(:taxon, stub_model(Taxon,
      :name => "Name",
      :rank => "Rank",
      :wgs => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Rank/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
