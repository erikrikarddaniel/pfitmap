# == Schema Information
#
# Table name: enzymes
#
#  id           :integer         not null, primary key
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  abbreviation :string(255)
#  enzymeclass  :string(255)
#  subclass     :string(255)
#  group        :string(255)
#  subgroup     :string(255)
#  subsubgroup  :string(255)
#

class Enzyme < ActiveRecord::Base
  attr_accessible :name, :parent_id, :abbreviation, :enzymeclass, :subclass, :group, :subgroup, :subsubgroup
  has_many :enzyme_profiles, dependent: :destroy
  has_many :hmm_profiles, through: :enzyme_profiles
  has_many :enzyme_proteins
  has_many :proteins, through: :enzyme_proteins
  validates :name, :presence => :true
  validates :abbreviation, :presence => :true
  has_many :children, :class_name => "Enzyme", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Enzyme", :foreign_key => "parent_id"

  
  def self.find_standard_enzymes(enzyme_ids)
    if enzyme_ids
      enzymes = Enzyme.find_all_by_id(enzyme_ids, :order => "parent_id, abbreviation")
      enzyme_tree = Enzyme.build_tree_from(enzymes)
      parent_ids = Enzyme.find_all_by_id(enzyme_ids, :order => "abbreviation", :conditions => "parent_id IS NULL").map { |e| e.id}
    else
      enzymes = Enzyme.find_all_by_parent_id(nil, :order => "abbreviation")
      parent_ids = Enzyme.find(:all, :order => "abbreviation", :conditions => "parent_id IS NULL").map { |e| e.id}
      enzyme_tree = Enzyme.build_tree_from(enzymes)
    end
    return enzyme_tree, parent_ids, enzymes
  end
  
  # All enzymes are sorted on the parent_id
  # so the root enzymes will come first
  def self.build_tree_from(enzymes)
    tree = {}
    enzyme_hash = {}
    enzymes.each do |e|
      enzyme_hash[e.id] = true
    end
    
    enzymes.each do |e|
      children = []
      e.children.order("abbreviation").each do |c|
        if enzyme_hash[c.id]
          children << c.id
        end
      end
      tree[e.id] = [e, children, e.proteins]
    end
    return tree
  end

  # Returns a string of enzyme abbreviations separated by ':' -- useful for sorting purposes
  def hierarchy
    parent ?  "#{parent.hierarchy}:#{abbreviation}" : abbreviation
  end
end
