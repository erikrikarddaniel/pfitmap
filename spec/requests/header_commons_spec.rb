require 'spec_helper'

describe "When Capy clicks the header link" do
  it "Home" do
    click_link "Home"
    save_and_open_page
    page.should have_selector('h1', 'Home')
  end
#  describe "check header in root_page" do
#    before { visit root_path }
#    click_link "Home"
#    it { should have_selector('li', "Home") }
#    it { should have_selector('li', "Contact") }
#    it { should have_selector('li', "Help") }
#  end
end
