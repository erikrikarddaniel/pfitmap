require 'spec_helper'

describe "Profile pages" do
  subject { page }
  
  describe "profile header should contain profiles" do
    before { visit profiles_path }
    it { should have_selector('h1', text: 'Listing profiles')}
    it { should have_selector('title', text: full_title('Profiles')) }
  end
end
