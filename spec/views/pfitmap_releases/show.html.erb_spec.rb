require 'spec_helper'

describe "pfitmap_releases/show" do
  before(:each) do
    @pfitmap_release = assign(:pfitmap_release, stub_model(PfitmapRelease))
  end

  it "renders attributes in <p>" do
    render
  end
end
