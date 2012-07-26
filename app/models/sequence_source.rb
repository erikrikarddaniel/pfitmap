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
  has_one :pfitmap_release
  validates :source, presence: true
  validates :name, presence: true
  validates :version, presence: true
  def list_name
    "#{source}:#{name}:#{version}"
  end

  def evaluate(head_release)
    db_sequences =  self.db_sequences
    logger.info "Evaluating..."
    db_sequences.each_with_index do |seq, index|
      if index % 100 == 0
        logger.info "Next 100 db_sequences"
      end
      hmm_profile_ids = seq.best_hmm_profiles(self)
      hmm_profiles = HmmProfile.find_all_by_id(hmm_profile_ids)
      hmm_profiles.each do |hmm_profile|
        if hmm_profile.evaluate?(seq,self)
          head_release.add_seq(seq, hmm_profile)
        end
      end
    end
  end
end
