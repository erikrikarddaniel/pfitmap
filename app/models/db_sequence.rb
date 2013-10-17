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
  has_many :hmm_result_rows
  has_many :db_entries
  has_many :pfitmap_sequences
  has_many :db_sequence_best_profiles
  has_many :best_hmm_profiles, :through => :db_sequence_best_profiles, :source => :hmm_profile
  has_many :hmm_score_criteria, :through => :best_hmm_profiles

  #virtual attributes used in controllers
  attr_accessor :hmm_profile, :hmm_profiles, :score

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

  def best_hmm_result_rows_for(sequence_source)
    r = []
    best_hmm_profiles_for(sequence_source).each do |profile|
      r << profile.hmm_results.find_by_sequence_source_id(sequence_source.id).hmm_result_rows.find_by_db_sequence_id(self.id)
    end
    r
  end

  # A method that returns the best hmm profile object
  def best_hmm_profiles_for(sequence_source)
    dsbps = self.db_sequence_best_profiles.\
    find_all_by_sequence_source_id(sequence_source.id, 
                                   :include => hmm_profile)
    dsbps.map{ |dsbp| dsbp.hmm_profile }
  end

  # The result row having the highest fullseq_score.
  def best_hmm_result_row(sequence_source)
    self.db_sequence_best_profiles.find_by_sequence_source_id(sequence_source.id).hmm_result_row
  end
end
