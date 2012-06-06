require 'spec_helper'

describe "sequence_sources/show" do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  before(:each) do
    @sequence_source = assign(:sequence_source, stub_model(SequenceSource,
      :source => "Source",
      :name => "Name",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Source/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
  end
end
