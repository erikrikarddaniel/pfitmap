# == Schema Information
#
# Table name: db_sequences
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  sequence   :text
#

class DbSequence < ActiveRecord::Base
  attr_accessible :hmm_result_row_id, :hmm_db_hit_id, :sequence
  belongs_to :hmm_result_row
  belongs_to :hmm_db_hit
  validates :hmm_result_row_id, presence: true
  validates :hmm_db_hit_id, presence: true
  validates :sequence, presence: true

  # Given a database, it will browse through all profiles in order to
  # find all hits 

  # All result rows that share sequence_db.id
  def all_hits(sequence_db)
    hmm_results = HmmResult.where("sequence_db_id = ?", sequence_db.id)
  end
end
