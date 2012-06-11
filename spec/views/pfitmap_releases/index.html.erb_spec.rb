require 'spec_helper'

describe "pfitmap_releases/index" do
  before(:each) do
    assign(:pfitmap_releases, [
      stub_model(PfitmapRelease),
      stub_model(PfitmapRelease)
    ])
  end

  it "renders a list of pfitmap_releases" do
    render
  end
end
