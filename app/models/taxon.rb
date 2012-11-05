# == Schema Information
#
# Table name: taxons
#
#  id             :integer         not null, primary key
#  ncbi_taxon_id  :integer
#  name           :string(255)
#  rank           :string(255)
#  wgs            :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  parent_ncbi_id :integer
#

class Taxon < ActiveRecord::Base
  # The hierarchy association uses ncbi_ids to make it easier to construct from retrieved data
  belongs_to :parent, :class_name => "Taxon", :foreign_key => "parent_ncbi_id", :primary_key => "ncbi_taxon_id"
  has_many :children, :class_name => "Taxon", :foreign_key => "parent_ncbi_id", :primary_key => "ncbi_taxon_id"
  has_many :protein_counts

  def self_and_ancestors
    all_up_to_root_rec(self, [])
  end

  def self.roots
    Taxon.find(:all, conditions: ["parent_ncbi_id IS NULL"])
  end

  def self.all_ranks
    hierarchy = {"superkingdom" => 1, "phylum" => 2, "class" => 3, "order" => 4, "family" => 5, "genus" => 6, "species" => 7}
    ranks = self.uniq.pluck(:rank)
    ranks.sort_by{ |r| hierarchy[r] ? hierarchy[r] : 10}
  end

  def self.from_rank(taxon_rank)
    self.where('rank = ?', taxon_rank)
  end

  def to_s
    "#{rank} #{name}"
  end

  private
  
  def all_up_to_root_rec(t, ancestors)
    ancestors << t
    if t.parent and t.parent != t
      all_up_to_root_rec(t.parent, ancestors)
    else
      return ancestors
    end
  end


end
