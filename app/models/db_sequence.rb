# == Schema Information
#
# Table name: db_sequences
#
#  id          :integer         not null, primary key
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  aa_sequence :text
#

class DbSequence < ActiveRecord::Base
  attr_accessible :aa_sequence
  has_many :hmm_result_rows
  has_many :hmm_db_hits
  validates :aa_sequence, presence: true

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
end
