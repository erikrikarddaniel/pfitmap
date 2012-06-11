require 'spec_helper'

describe "pfitmap_releases/new" do
  before(:each) do
    assign(:pfitmap_release, stub_model(PfitmapRelease).as_new_record)
  end

  it "renders new pfitmap_release form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pfitmap_releases_path, :method => "post" do
    end
  end
end
