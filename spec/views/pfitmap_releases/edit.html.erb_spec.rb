require 'spec_helper'

describe "pfitmap_releases/edit" do
  before(:each) do
    @pfitmap_release = assign(:pfitmap_release, stub_model(PfitmapRelease))
  end

  it "renders the edit pfitmap_release form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pfitmap_releases_path(@pfitmap_release), :method => "post" do
    end
  end
end
