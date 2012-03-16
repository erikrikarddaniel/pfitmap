require 'spec_helper'

describe "When Capy clicks the header link" do
  subject{ page }
  before{ visit root_path }
  it "Home" do
    click_link "Home"
    page.should have_selector 'title', text: full_title(''))
  end
#  describe "check header in root_page" do
#    before { visit root_path }
#    click_link "Home"
#    it { should have_selector('li', "Home") }
#    it { should have_selector('li', "Contact") }
#    it { should have_selector('li', "Help") }
#  end
end
