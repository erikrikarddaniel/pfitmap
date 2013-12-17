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
  has_many :hmm_profile_release_statistics
  validates :source, presence: true
  validates :name, presence: true
  validates :version, presence: true

  def to_s
    "SequenceSource: #{name}-#{version}"
  end

  def list_name
    "#{source}:#{name}:#{version}"
  end

  def evaluate_logger
    @@evaluate_logger ||= ActiveSupport::Logger.new(Rails.root.join('log/evaluate.log'))
  end

  def evaluate(head_release, user)
    evaluate_logger.info "#{Time.now} Start evaluating sequence source: #{self.name}"

    @sequences = []
    profile_hash = {}
    HmmProfile.includes(:hmm_score_criteria).each do |profile|
      profile_hash[profile.id] = profile
    end

    DbSequence.includes(:db_sequence_best_profiles).find_each do |seq|
      seq.db_sequence_best_profiles.each do |view_row|
        if view_row.sequence_source_id == self.id
          hmm_profile = profile_hash[view_row.hmm_profile_id]
          
          if hmm_profile.evaluate_no_sql(seq, self, hmm_profile.hmm_score_criteria, view_row.fullseq_score)
            head_release.add_seq(seq, hmm_profile)
          end
        end
      end
    end
    evaluate_logger.info "#{Time.now} Evaluation of sequence source #{self.name} was successful!"
  end
end

