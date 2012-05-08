# == Schema Information
#
# Table name: db_sequences
#
#  id                :integer         not null, primary key
#  hmm_result_row_id :integer
#  hmm_db_hit_id     :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  sequence          :text
#

require 'spec_helper'

describe DbSequence do
  pending "add some examples to (or delete) #{__FILE__}"
end
