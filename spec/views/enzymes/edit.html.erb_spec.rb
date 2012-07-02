require 'spec_helper'

describe "enzymes/edit" do
  before(:each) do
    @enzyme = assign(:enzyme, stub_model(Enzyme,
      :name => "MyString"
    ))
  end

  it "renders the edit enzyme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => enzymes_path(@enzyme), :method => "post" do
      assert_select "input#enzyme_name", :name => "enzyme[name]"
    end
  end
end
