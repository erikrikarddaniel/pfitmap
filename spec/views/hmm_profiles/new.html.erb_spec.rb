require 'spec_helper'

describe "hmm_profiles/new" do
  before(:each) do
    assign(:hmm_profile, stub_model(HmmProfile,
      :name => "MyString",
      :version => "MyString",
      :hierarchy => "MyString",
      :parent_hmm_profile_id => 1
    ).as_new_record)
  end

  it "renders new hmm_profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hmm_profiles_path, :method => "post" do
      assert_select "input#hmm_profile_name", :name => "hmm_profile[name]"
      assert_select "input#hmm_profile_version", :name => "hmm_profile[version]"
      assert_select "input#hmm_profile_hierarchy", :name => "hmm_profile[hierarchy]"
      assert_select "input#hmm_profile_parent_hmm_profile_id", :name => "hmm_profile[parent_hmm_profile_id]"
    end
  end
end
