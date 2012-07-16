# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Protein do
  pending "add some examples to (or delete) #{__FILE__}"
end
