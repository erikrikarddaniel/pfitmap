# == Schema Information
#
# Table name: protein_counts
#
#  id                       :integer         not null, primary key
#  no_genomes               :integer
#  no_proteins              :integer
#  no_genomes_with_proteins :integer
#  protein_id               :integer
#  pfitmap_release_id       :integer
#  taxon_id                 :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  obs_as_genome            :boolean
#


## obs_as_genome is a flag indicating that the taxon has been observed 
## as a genome together with a protein.
  
class ProteinCount < ActiveRecord::Base
  attr_accessible :no_genomes, :no_proteins, :no_genomes_with_proteins, :obs_as_genome
  belongs_to :protein
  belongs_to :pfitmap_release
  belongs_to :taxon

  def self.from_rank(rank)
    if rank
      self.find(:all, joins: :taxon, conditions: ["Taxons.rank = ?", rank])
    else
      self.find(:all, :joins => :taxon, conditions: ["Taxons.rank IS NULL"])
    end
  end

  def add_genome
    self.no_genomes += 1
    self.save
  end
  
  def self.add_hit(protein, taxons, pr)
    # Check if the genome refferred to have got a hit from before.
    # If not, then this is the first out of possibly many proteins
    # to hit this protein_count.
    first_taxon = taxons.first
    first_protein_count = self.find(:first, :conditions => ["protein_id = ? AND taxon_id = ? AND pfitmap_release_id = ?", protein.id, first_taxon.id, pr.id])
    first_protein = !(first_protein_count.obs_as_genome)
    if first_protein
      first_protein_count.obs_as_genome = true
      first_protein_count.save
    end
        
    taxons.each do |taxon|

      protein_count = self.find(:first, :conditions => ["protein_id = ? AND taxon_id = ? AND pfitmap_release_id = ?", protein.id, taxon.id, pr.id])
      if first_protein
        protein_count.no_genomes_with_proteins += 1
      end
      protein_count.no_proteins += 1
      protein_count.save
    end
  end
end
