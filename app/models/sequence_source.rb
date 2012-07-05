# == Schema Information
#
# Table name: sequence_sources
#
#  id         :integer         not null, primary key
#  source     :string(255)
#  name       :string(255)
#  version    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class SequenceSource < ActiveRecord::Base
  attr_protected :id, :created_at, :updated_at
  has_many :hmm_results, :dependent => :destroy
  has_many :hmm_profiles, :through => :hmm_results
  has_many :hmm_result_rows, :through => :hmm_results
  has_many :db_sequences, :through => :hmm_result_rows
  has_many :view_db_sequence_best_profiles
  validates :source, presence: true
  validates :name, presence: true
  validates :version, presence: true
  def list_name
    "#{source}:#{name}:#{version}"
  end

  def evaluate(head_release)
    db_sequences =  self.db_sequences
    db_sequences.each do |seq|
      hmm_profile_id = seq.best_hmm_profile(self)
      hmm_profile = HmmProfile.find(hmm_profile_id)
      if hmm_profile.evaluate?(seq,self)
        head_release.add_seq(seq)
      end
    end
  end
end
