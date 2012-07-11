# == Schema Information
#
# Table name: hmm_profiles
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  version      :string(255)
#  hierarchy    :string(255)
#  parent_id    :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  protein_name :string(255)
#

class HmmProfile < ActiveRecord::Base
  # Could be a reason to remove parent_id from accessible attributes
  attr_accessible :name, :protein_name, :version, :hierarchy, :parent_id
  attr_accessor :release_statistics
  has_many :children, :class_name => "HmmProfile", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "HmmProfile", :foreign_key => "parent_id"
  has_many :hmm_results
  has_many :hmm_score_criteria, :dependent => :destroy
  has_many :enzyme_profiles
  has_many :enzymes, :through => :enzyme_profiles
  has_many :db_sequence_best_profiles
  has_many :best_profile_sequences, through: :db_sequence_best_profiles, source: :db_sequence
  has_many :pfitmap_sequences
  validates :name, presence: true
  validates :version, presence: true
  validates :hierarchy, presence: true, :uniqueness => :true
  # A method to pick up all criterias independent of type
  def inclusion_criteria
    self.hmm_score_criteria
  end

  # An instance method to find the root node for a specific hmm profile.
  # Calls the recursive function with the id of the current profile.
  def last_parent_id()
    last_parent_recursion(self.id)
  end
  
  # A class method to pick up all root nodes directly from the database.
  def self.last_parents()
    HmmProfile.where("parent_id IS NULL")
  end

  def evaluate?(db_sequence, sequence_source)
    best_profile = (db_sequence.best_hmm_profile_id(sequence_source) == self.id)
    bool = self.inclusion_criteria.inject(best_profile) { |result, element| result && element.evaluate?(db_sequence,sequence_source) } 
    return bool
  end

<<<<<<< HEAD
  # Provides a concatenation of name and protein name useful for display
  def description
    "#{name}#{protein_name ? " (#{protein_name})" : ""}"
=======
  def included_statistics(sequence_source)
    all_included_sequence_ids = sequence_source.pfitmap_release.db_sequence_ids
    [DbSequenceBestProfile.where('db_sequence_id IN (?) AND hmm_profile_id = ? AND sequence_source_id = ?', all_included_sequence_ids, self.id, sequence_source.id).count,
     DbSequenceBestProfile.where('db_sequence_id IN (?) AND hmm_profile_id = ? AND sequence_source_id = ?', all_included_sequence_ids, self.id, sequence_source.id).minimum(:db_sequence_id),
     DbSequenceBestProfile.where('db_sequence_id IN (?) AND hmm_profile_id = ? AND sequence_source_id = ?', all_included_sequence_ids, self.id, sequence_source.id).maximum(:db_sequence_id)]
  end


  def not_included_statistics(sequence_source)
    best_profile_sequence_ids(sequence_source) 
  end

  def best_profile_sequences(sequence_source)
    DbSequence.joins(:db_sequence_best_profiles).where(:db_sequence_best_profiles => {hmm_profile_id: self.id, sequence_source_id: sequence_source.id})
  end
  
  def best_profile_sequence_ids(sequence_source)
    DbSequenceBestProfile.select(:db_sequence_id).where(:db_sequence_best_profiles => {hmm_profile_id: self.id, sequence_source_id: sequence_source.id})
>>>>>>> pfitmap_release
  end

  private
  def last_parent_recursion(id)
    parent = HmmProfile.find(id)
    if parent.parent_id == nil
      return id
    else
      last_parent_recursion(parent.parent_id)
    end
  end
end
