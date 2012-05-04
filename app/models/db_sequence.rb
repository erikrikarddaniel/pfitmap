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

class DbSequence < ActiveRecord::Base
  attr_accessible :hmm_result_row_id, :hmm_db_hit_id, :sequence
  belongs_to :hmm_result_row
  belongs_to :hmm_db_hit
end
