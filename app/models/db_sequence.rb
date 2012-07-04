# == Schema Information
#
# Table name: db_sequences
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class DbSequence < ActiveRecord::Base
  has_many :hmm_result_rows
  has_many :hmm_db_hits
  has_many :pfitmap_sequences

  #virtual attributes used in controllers
  attr_accessor :hmm_profile, :score

  # Given a source, it will browse through all profiles in order to
  # find all hits.
  #
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
  def best_hmm_profile(sequence_source)
    max_score_row = self.best_hmm_result_row()
    return max_score_row.hmm_result.hmm_profile.id
  end

  # Method for finding the profile OBJECT and its fullseq_score
  def best_hmm_profile_with_score
    max_score_row = self.best_hmm_result_row()
    return [max_score_row.hmm_result.hmm_profile.id, max_score_row.fullseq_score]
  end

  # The result row having the highest fullseq_score.
  def best_hmm_result_row
    return  HmmResultRow.where("db_sequence_id = ?", self.id).order("fullseq_score DESC").first
  end
end
