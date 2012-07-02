require 'spec_helper'

describe "enzymes/show" do
  before(:each) do
    @enzyme = assign(:enzyme, stub_model(Enzyme,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
