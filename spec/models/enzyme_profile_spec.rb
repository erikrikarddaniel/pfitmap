# == Schema Information
#
# Table name: enzyme_profiles
#
#  id             :integer         not null, primary key
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe EnzymeProfile do
  pending "add some examples to (or delete) #{__FILE__}"
end
