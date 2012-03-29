# == Schema Information
#
# Table name: results
#
#  id          :integer         not null, primary key
#  date        :date
#  profile_id  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  sequence_id :integer
#

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
