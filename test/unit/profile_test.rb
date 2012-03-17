# == Schema Information
#
# Table name: profiles
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  parent_profile_id :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

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
