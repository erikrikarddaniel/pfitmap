require 'spec_helper'

describe "enzymes/new" do
  before(:each) do
    assign(:enzyme, stub_model(Enzyme,
      :name => "MyString"
    ).as_new_record)
    @hmm_profiles = [assign(:hmm_profile, stub_model(HmmProfile, :name => "MyString"))]
  end

  it "renders new enzyme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => enzymes_path, :method => "post" do
      assert_select "input#enzyme_name", :name => "enzyme[name]"
    end
  end
end
