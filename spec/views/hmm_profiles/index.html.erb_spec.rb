# Decided to only use integration tests instead of specific views tests
# require 'spec_helper'

# describe "hmm_profiles/index" do
#   before(:each) do
#     @hmm_profile_001 = FactoryGirl.create(:hmm_profile_001)
#     @hmm_profile_00100  = FactoryGirl.create(:hmm_profile_00100)
#     @hmm_profile_00101  = FactoryGirl.create(:hmm_profile_00101)
#   end

#   it "renders a nested list of hmm_profiles" do
#     render 
  
#     assert_select "li", :text => "Name".to_s, :count => 2
#     assert_select "li", :text => "Version".to_s, :count => 2
#     assert_select "li", :text => "Hierarchy".to_s, :count => 2
#     assert_select "li", :text => 1.to_s, :count => 2
#   end
# end
