# == Schema Information
#
# Table name: hmm_profiles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  hierarchy  :string(255)
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class HmmProfile < ActiveRecord::Base
  # Could be a reason to remove parent_id from accessible attributes
  attr_accessible :name, :version, :hierarchy, :parent_id
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
