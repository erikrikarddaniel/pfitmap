require 'spec_helper'

describe "proteins/show" do
  before(:each) do
    @protein = assign(:protein, stub_model(Protein,
      :name => "Name",
      :rank => "Rank",
      :HmmProfile => nil,
      :Enzyme => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Rank/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
