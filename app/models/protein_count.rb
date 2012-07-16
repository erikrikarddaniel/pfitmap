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
#

class ProteinCount < ActiveRecord::Base
  belongs_to :protein
  belongs_to :pfitmap_release
  belongs_to :taxon

  # The "dry run", creates all rows that is needed
  # for a specified pfitmap_release by retrieving 
  # all whole genome sequenced genomes and their full
  # taxonomic hierarchy.
  def initialize_dry(pr)
    all_wgs_gis_with_taxa =  
  end

end
