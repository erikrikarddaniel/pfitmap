require 'test_helper'
#require 'Profile'

class ProfileTest < ActiveSupport::TestCase
  test "insert profile" do
    p1=Profile.new(:name => "first!")
    p1.save
    p2=Profile.find_by_name("first!")
    assert(p2.name == "first!")
    assert_nil(p2.parent_profile_id)
  end
  test "insert result" do
    p=Profile.new(:name => "second!")
    p.save
    p.results.create
    assert(p.results != [])
  end
end
