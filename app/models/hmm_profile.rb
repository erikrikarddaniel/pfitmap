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
  has_many :children, :class_name => "HmmProfile", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "HmmProfile", :foreign_key => "parent_id"
  has_many :hmm_results
  has_one :hmm_score_criterion, :dependent => :destroy
  validates :name, presence: true
  validates :version, presence: true
  validates :hierarchy, presence: true
  # An instance method to find the root node for a specific hmm profile.
  # Calls the recursive function with the id of the current profile.
  def last_parent_id()
    last_parent_recursion(self.id)
  end
  
  # A class method to pick up all root nodes directly from the database.
  def self.last_parents()
    HmmProfile.where("parent_id IS NULL")
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
