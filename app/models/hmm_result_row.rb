# == Schema Information
#
# Table name: hmm_result_rows
#
#  id             :integer         not null, primary key
#  target_name    :string(255)
#  target_acc     :string(255)
#  query_name     :string(255)
#  query_acc      :string(255)
#  fullseq_evalue :float
#  fullseq_score  :float
#  fullseq_bias   :float
#  bestdom_evalue :float
#  bestdom_score  :float
#  bestdom_bias   :float
#  domnumest_exp  :float
#  domnumest_reg  :integer
#  domnumest_clu  :integer
#  domnumest_ov   :integer
#  domnumest_env  :integer
#  domnumest_rep  :integer
#  domnumest_inc  :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  hmm_result_id  :integer
#  domnumest_dom  :integer
#  db_sequence_id :integer
#

class HmmResultRow < ActiveRecord::Base
  # Could be a reason to add hmm_result_id to this list
  attr_protected :id, :created_at, :updated_at
  belongs_to :hmm_result
  has_many :hmm_db_hits, :through => :db_sequence
  has_many :view_db_sequence_best_profiles
  belongs_to :db_sequence
  validates :hmm_result_id, presence: true
  validates :db_sequence_id, presence: true

  def best_hit_evalue?
    db_seq = DbSequence.find(self.db_sequence_id)
    all_result_rows = db_seq.all_hits(self.hmm_result.sequence_source)
    all_evalues = []
    all_result_rows.each do |row|
      all_evalues.append(row.fullseq_evalue)
    end
    top_evalue = all_evalues.min
    return (top_evalue == self.fullseq_evalue)
  end

  def best_hit_score?
    db_seq = DbSequence.find(self.db_sequence_id)
    all_result_rows = db_seq.all_hits(self.hmm_result.sequence_source)
    all_scores = []
    all_result_rows.each do |row|
      all_scores.append(row.fullseq_score)
    end
    top_score = all_scores.max
    return (top_score == self.fullseq_score)
  end

  def dbs_included
    db_hits = DbSequence.find(self.db_sequence_id).hmm_db_hits
    all_dbs = []
    db_hits.each do |db_hit|
      all_dbs.append(db_hit.db)
    end
    return all_dbs.uniq
  end
end
