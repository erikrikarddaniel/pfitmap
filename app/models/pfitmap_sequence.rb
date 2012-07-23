# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id                 :integer         not null, primary key
#  db_sequence_id     :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  pfitmap_release_id :integer
#  hmm_profile_id     :integer
#

class PfitmapSequence < ActiveRecord::Base
  attr_accessible :db_sequence_id, :pfitmap_release_id, :hmm_profile_id
  belongs_to :db_sequence
  belongs_to :pfitmap_release
  belongs_to :hmm_profile
  has_many :hmm_db_hits, :through => :db_sequence
  has_one :sequence_source, :through => :pfitmap_release

  # calculate_counts(pr : pfitmap_release, ncbi_gi_taxon_hash)
  def calculate_counts(pr, ncbi_gi_taxon_hash)
    # This line can later pick out db_hits from 
    # a specified db with db_hits_from method
    db_hits = self.hmm_db_hits
    best_profile = self.hmm_profile
    proteins = best_profile.all_proteins_including_parents
    
    db_hits.each do |db_hit|
      ncbi_taxon_id = ncbi_gi_taxon_hash[db_hit.gi]
      # If genome_taxon = nil, could be useful to raise some exception
      genome_taxon = Taxon.find_by_ncbi_taxon_id(ncbi_taxon_id)
      taxons = genome_taxon.self_and_ancestors
      proteins.each do |protein|
        ProteinCount.add_hit(protein, taxons, pr)
      end
    end
  end

  def db_hits_from(db_string)
    if db_string
      self.hmm_db_hits.where("db = ?", db_string)
    else
      self.hmm_db_hits
    end
  end

end
