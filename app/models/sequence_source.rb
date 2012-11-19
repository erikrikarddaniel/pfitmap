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

  def to_s
    "SequenceSource: #{name}-#{version}"
  end

  def list_name
    "#{source}:#{name}:#{version}"
  end

  def evaluate(head_release, user)
    begin
      db_sequences =  self.db_sequences
      hmm_profiles = HmmProfile.all
      db_sequences.each_with_index do |seq, index|
        hmm_profiles.each do |hmm_profile|
          # Evaluate checks that the profile is among
          # the best profiles
          if hmm_profile.evaluate?(seq,self)
            head_release.add_seq(seq, hmm_profile)
          end
        end
      end
    rescue
      logger.info "Evaluation of sequence source ended with an error!"
      logger.info " This is the error message: #{$!}"
#      UserMailer.evaluate_failure_email(user, self, $!).deliver
    else
      logger.info "Evaluation of sequence source was successful!"
#      UserMailer.evaluate_success_email(user, self).deliver
    end      
  end
end

