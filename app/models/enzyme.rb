# == Schema Information
#
# Table name: enzymes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  parent_id  :integer
#

class Enzyme < ActiveRecord::Base
  attr_accessible :name, :parent_id
  has_many :enzyme_profiles, dependent: :destroy
  has_many :hmm_profiles, through: :enzyme_profiles
  has_many :enzyme_proteins
  has_many :proteins, through: :enzyme_proteins
  validates :name, :presence => :true
  has_many :children, :class_name => "Enzyme", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Enzyme", :foreign_key => "parent_id"

  
  def self.find_standard_enzymes(enzyme_ids)
    if enzyme_ids
      enzymes = Enzyme.find_all_by_id(enzyme_ids, :order => "parent_id, name")
      enzyme_tree = Enzyme.build_tree_from(enzymes)
      parent_ids = Enzyme.find_all_by_id(enzyme_ids, :order => "name", :conditions => "parent_id IS NULL").map { |e| e.id}
    else
      enzymes = Enzyme.find_all_by_parent_id(nil, :order => "name")
      parent_ids = Enzyme.find(:all, :order => "name", :conditions => "parent_id IS NULL").map { |e| e.id}
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
      e.children.order("name").each do |c|
        if enzyme_hash[c.id]
          children << c.id
        end
      end
      tree[e.id] = [e, children, e.proteins]
    end
    return tree
  end
end
