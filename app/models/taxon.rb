# == Schema Information
#
# Table name: taxons
#
#  id                 :integer         not null, primary key
#  ncbi_taxon_id      :integer
#  wgs                :boolean
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  domain             :string(255)
#  kingdom            :string(255)
#  phylum             :string(255)
#  taxclass           :string(255)
#  taxorder           :string(255)
#  family             :string(255)
#  genus              :string(255)
#  species            :string(255)
#  strain             :string(255)
#  pfitmap_release_id :integer
#

class Taxon < ActiveRecord::Base
  # The hierarchy association uses ncbi_ids to make it easier to construct from retrieved data
  has_many :protein_counts

  RANKS = ["superkingdom", "kingdom", "phylum", "class", "order", "family", "genus", "species"]
  TAXA =  ["domain", "kingdom", "phylum", "taxclass", "taxorder", "family", "genus", "species","strain"]
  TAXA_PROPER_NAMES = {"domain"=>"Domain", "kingdom"=>"Kingdom", "phylum"=>"Phylum", "taxclass"=>"Class", "taxorder"=>"Order", "family"=>"Family", "genus"=>"Genus", "species"=>"Species","strain"=>"Strain"}
#TODO remove since we send over all taxons and do the tree structure in D3 or other
#  def self_and_ancestors
#    all_up_to_root_rec(self, [])
#  end
#  def self.roots
#    Taxon.find(:all, conditions: ["parent_ncbi_id "])
#  end
#  def self.all_ranks
#    hierarchy = {"superkingdom" => 1, "kingdom" => 2, "phylum" => 3, "class" => 4, "order" => 5, "family" => 6, "genus" => 7, "species" => 8}
#    ranks = self.uniq.pluck(:rank)
#    ranks.sort_by{ |r| hierarchy[r] ? hierarchy[r] : 10}
#  end
#  def self.from_rank(taxon_rank)
#    self.where('rank = ?', taxon_rank).order(:hierarchy)
#  end

  def to_s
    "#{rank} #{name}"
  end

#  private  
#  def all_up_to_root_rec(t, ancestors)
#    ancestors << t
#    if t.parent and t.parent != t
#      all_up_to_root_rec(t.parent, ancestors)
#    else
#      return ancestors
#    end
#  end


end
