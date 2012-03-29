# == Schema Information
#
# Table name: hmm_result_rows_hmm_db_hits
#
#  id              :integer         not null, primary key
#  hmmResultRow_id :integer
#  hmmDbHit_id     :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class HmmResultRowsHmmDbHit < ActiveRecord::Base
  belongs_to :hmmResultRow
  belongs_to :hmmDbHit
end
