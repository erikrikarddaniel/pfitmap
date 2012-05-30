# == Schema Information
#
# Table name: db_sequences
#
#  id                  :integer         not null, primary key
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  best_hmm_profile_id :integer
#

class DbSequence < ActiveRecord::Base
  has_many :hmm_result_rows
  has_many :hmm_db_hits

  # Given a database, it will browse through all profiles in order to
  # find all hits 

  # All result rows that share sequence_source.id
  def all_hits(sequence_source)
    hmm_results = HmmResult.where("sequence_source_id = ?", sequence_source.id)
    hmm_result_rows = []
    hmm_results.each do
      rows_temp = HmmResultRow.where("db_sequence_id = ?", self.id)
      hmm_result_rows.concat(rows_temp)
    end
    return hmm_result_rows
  end

  # A method that returns the best hmm profile id.
  def best_hmm_profile
    max_score_row = self.hmm_result_rows.sort_by{ |row| row.fullseq_score }.last
    return max_score_row.hmm_result.hmm_profile.id
  end
end
