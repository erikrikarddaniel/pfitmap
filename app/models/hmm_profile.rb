# == Schema Information
#
# Table name: hmm_profiles
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  version               :string(255)
#  parent_id             :integer
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  protein_name          :string(255)
#  hmm_logo_file_name    :string(255)
#  hmm_logo_content_type :string(255)
#  hmm_logo_file_size    :integer
#  hmm_logo_updated_at   :datetime
#

class HmmProfile < ActiveRecord::Base
  # Could be a reason to remove parent_id from accessible attributes
  attr_accessible :name, :protein_name, :version, :parent_id, :hmm_logo
  attr_accessor :release_statistics
  has_many :children, :class_name => "HmmProfile", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "HmmProfile", :foreign_key => "parent_id"
  has_many :hmm_results, :dependent => :destroy
  has_many :hmm_score_criteria, :dependent => :destroy
  has_many :enzyme_profiles, :dependent => :destroy
  has_many :enzymes, :through => :enzyme_profiles
  has_many :proteins, :dependent => :destroy
  has_many :db_sequence_best_profiles, :dependent => :destroy
  has_many :best_profile_sequences, through: :db_sequence_best_profiles, source: :db_sequence, :dependent => :destroy
  has_many :pfitmap_sequences, :dependent => :destroy
  has_many :hmm_profile_release_statistics, :dependent => :destroy

  has_attached_file :hmm_logo, :styles => { :medium => "40000x400>", :thumb => "10000x100>" }

  validates :name, presence: true
  validates :version, presence: true
  validates :protein_name, presence: true

  def hierarchy
    if parent
      "#{parent.hierarchy}:#{protein_name}"
    else
      protein_name
    end
  end

  def hmm_result_for(ss)
    self.hmm_results.where("sequence_source_id = ?", ss.id).first
  end

  def to_s
    "HmmProfile: #{protein_name} #{parent}"
  end

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

  # Finds out if the profile is a perfect match for the given db_sequence
  def evaluate?(db_sequence, sequence_source)
    best_profile = DbSequenceBestProfile.include_profile?(db_sequence,
                                                          sequence_source,
                                                          self)
    # best_profile = db_sequence.best_hmm_profiles(sequence_source).include?(self)
    if best_profile
      has_criteria = self.inclusion_criteria != []
      bool = self.inclusion_criteria.inject(best_profile && has_criteria) { |result, element| result && element.evaluate?(db_sequence,sequence_source) }
    else
      bool = false
    end
    return bool
  end
  # Evaluates under the assumption that the profile is the best_profile for 
  # that db_sequence and sequence_source
  def evaluate_no_sql(db_sequence, sequence_source, inclusion_criteria, fullseq_score)
    has_criteria = inclusion_criteria != []
    bool = inclusion_criteria.inject(has_criteria) { |result, element| result && element.evaluate_with_score?(db_sequence,sequence_source, fullseq_score) }
  end

  # Provides a concatenation of name and protein name useful for display
  def description
    "#{name}#{protein_name ? " (#{protein_name})" : ""}"
  end

  def all_parents_including_self
    all_parents_recursion([],self)
  end

  def all_proteins_including_parents
    proteins = []
    profiles = all_parents_including_self
    profiles.each do |profile|
        proteins += profile.proteins
    end
    proteins.uniq
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

  def all_parents_recursion(acc, profile)
    parent_profile = profile.parent
    acc << profile
    if parent_profile
      all_parents_recursion(acc, parent_profile)
    else
      return acc
    end
  end
end
