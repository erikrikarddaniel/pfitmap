require 'spec_helper'

describe "hmm_profiles/index" do
  before(:each) do
    assign(:hmm_profiles, [
      stub_model(HmmProfile,
        :name => "Name",
        :version => "Version",
        :hierarchy => "Hierarchy",
        :parent_hmm_profile_id => 1
      ),
      stub_model(HmmProfile,
        :name => "Name",
        :version => "Version",
        :hierarchy => "Hierarchy",
        :parent_hmm_profile_id => 1
      )
    ])
  end

  it "renders a list of hmm_profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hierarchy".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
