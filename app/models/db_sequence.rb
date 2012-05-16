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

  # All result rows that share sequence_db.id
  def all_hits(sequence_db)
    hmm_results = HmmResult.where("sequence_db_id = ?", sequence_db.id)
  end
end
