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

## no_proteins is the number of the current type of protein in the current taxon

## no_genomes_with_proteins is the number of genomes in the current taxon where
## the current protein has been observed.

## obs_as_genome is a flag indicating that the taxon has been observed 
## as a genome together with a protein.
  
class ProteinCount < ActiveRecord::Base
  attr_accessible :no_proteins, :no_genomes_with_proteins, :obs_as_genome, :released_db_id, :taxon_id, :protein_id, :counted_accessions, :all_accessions
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

  
  def self.add_hit(protein, taxons, pr)
    # Check if the genome refferred to have got a hit from before, meaning the number of genomes with proteins should be incremented. If not, then this is the first out of possibly many proteins to hit this protein_count.
    first_taxon = taxons.first
    first_protein_count = self.find(:first, :conditions => ["protein_id = ? AND taxon_id = ? AND pfitmap_release_id = ?", protein.id, first_taxon.id, pr.id])
    first_protein = !(first_protein_count.obs_as_genome)
    if first_protein
      first_protein_count.obs_as_genome = true
      first_protein_count.save
    end

    taxons.each do |taxon|
      if first_protein
        ProteinCount.where("protein_id = ? AND taxon_id = ? AND pfitmap_release_id = ?", protein.id, taxon.id, pr.id).update_all("no_genomes_with_proteins = no_genomes_with_proteins + 1, no_proteins = no_proteins + 1")
      else
        ProteinCount.where("protein_id = ? AND taxon_id = ? AND pfitmap_release_id = ?", protein.id, taxon.id, pr.id).update_all("no_proteins = no_proteins + 1")
      end
    end
  end
end
