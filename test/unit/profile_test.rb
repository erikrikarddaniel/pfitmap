require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "insert profile" do
    Profile.create(:name => "first!")
    p1=Profiles.find_by_name("first!")
    assert(p1.name == "first!")
    assert_nil(p1.parent_profile_id)
  end
  #test "whether profile was inserted" do
  #  @p=Profiles.find_by_name("first!")    
#assert
#  end
end
