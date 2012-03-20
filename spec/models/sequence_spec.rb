# == Schema Information
#
# Table name: sequences
#
#  id         :integer         not null, primary key
#  seq        :string(255)
#  biosql_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Sequence do
  pending "add some examples to (or delete) #{__FILE__}"
end
