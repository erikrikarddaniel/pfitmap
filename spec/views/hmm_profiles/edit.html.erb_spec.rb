# require 'spec_helper'

# describe "hmm_profiles/edit" do
#   before(:each) do
#     @hmm_profile = assign(:hmm_profile, stub_model(HmmProfile,
#       :name => "MyString",
#       :version => "MyString",
#       :hierarchy => "MyString",
#       :parent_hmm_profile_id => 1
#     ))
#   end

#   it "renders the edit hmm_profile form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => hmm_profiles_path(@hmm_profile), :method => "post" do
#       assert_select "input#hmm_profile_name", :name => "hmm_profile[name]"
#       assert_select "input#hmm_profile_version", :name => "hmm_profile[version]"
#       assert_select "input#hmm_profile_hierarchy", :name => "hmm_profile[hierarchy]"
#       assert_select "input#hmm_profile_parent_hmm_profile_id", :name => "hmm_profile[parent_hmm_profile_id]"
#     end
#   end
# end
