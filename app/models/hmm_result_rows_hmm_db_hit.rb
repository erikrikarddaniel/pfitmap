class HmmResultRowsHmmDbHit < ActiveRecord::Base
  belongs_to :hmm_result_row
  belongs_to :hmm_db_hit
end
