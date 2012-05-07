require 'spec_helper'

describe "hmm_profiles/show" do
  before(:each) do
    @hmm_profile = assign(:hmm_profile, stub_model(HmmProfile,
      :name => "Name",
      :version => "Version",
      :hierarchy => "Hierarchy",
      :parent_hmm_profile_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render 'hmm_profiles/form'
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hierarchy/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
