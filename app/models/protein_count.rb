# == Schema Information
#
# Table name: protein_counts
#
#  id                       :integer         not null, primary key
#  no_proteins              :integer
#  protein_id               :integer
#  taxon_id                 :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  released_db_id           :integer
#  no_genomes_with_proteins :integer
#  counted_accessions       :text
#  all_accessions           :text
#

## no_proteins is the number of the current type of protein in the current taxon

class ProteinCount < ActiveRecord::Base
  attr_accessible :no_proteins, :released_db_id, :taxon_id, :protein_id, :counted_accessions, :all_accessions
  belongs_to :protein
  belongs_to :taxon
  belongs_to :released_db
  def self.from_rank(rank)
    if rank
      self.joins(:taxon).where("Taxons.rank = ?", rank)
    else
      self.joins(:taxon)
    end
  end

  def self.from_protein(protein_id)
    if protein_id
      self.joins(:protein).where("Proteins.id = ?", protein_id)
    else
      self.joins(:protein)
    end
  end

  def self.protein_counts_hash_for(taxons, proteins, pr)
    protein_counts_hash = {}
    taxons.each do |taxon|
      column_hash = {}
      proteins.each do |protein|
        protein_count = self.where("taxon_id = ? AND protein_id = ? AND pfitmap_release_id = ?", taxon.id , protein.id, pr.id).first
        column_hash[protein.id] = protein_count
      end
      protein_counts_hash[taxon.id] = column_hash
    end
    return protein_counts_hash
  end

  def to_s
    "ProteinCount #{taxon} #{protein}, n. proteins: #{no_proteins}"
  end
end
