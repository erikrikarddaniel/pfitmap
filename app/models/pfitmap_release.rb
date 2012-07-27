# == Schema Information
#
# Table name: pfitmap_releases
#
#  id                 :integer         not null, primary key
#  release            :string(255)
#  release_date       :date
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  current            :boolean
#  sequence_source_id :integer
#


class PfitmapRelease < ActiveRecord::Base
  attr_accessible :release, :release_date, :sequence_source_id
  has_many :pfitmap_sequences, :dependent => :destroy
  has_many :db_sequences, :through => :pfitmap_sequences
  has_many :hmm_db_hits, :through => :db_sequences
  has_many :taxons
  has_many :protein_counts
  belongs_to :sequence_source
  validates :release, :presence => :true
  validates :release_date, :presence => :true
  validates_inclusion_of :current, :in => [true, false]
  validates :sequence_source_id, :presence => :true, :uniqueness => :true

  def make_current(current_release)
    if current_release != self
      if current_release
        current_release.current = false
        current_release.save
      end
      
      self.current = true
      self.save
    end
  end
  
  # Should only be called when there exists a head release
  def add_seq(db_seq, hmm_profile)
    existing = PfitmapSequence.find(:first, conditions: ["db_sequence_id = ? AND hmm_profile_id = ? AND pfitmap_release_id = ?", db_seq.id, hmm_profile.id, self.id])
    if not existing
      PfitmapSequence.create!(db_sequence_id: db_seq.id, pfitmap_release_id: self.id, hmm_profile_id: hmm_profile.id)
    end
  end

  def self.find_current_release
    return self.find_by_current('true', limit: 1)
  end

  def self.find_all_after_current
    current = self.find_current_release
    if current
      self.all(conditions: ["release >?", current.release])
    else
      self.all()
    end
  end
  
  # The "dry run", creates all rows that is needed
  # for a specified pfitmap_release by retrieving 
  # all whole genome sequenced genomes and their full
  # taxonomic hierarchy.
  def protein_counts_initialize_dry
    if Rails.env == "test"
      taxons = BiosqlWeb.all_wgs_with_full_taxa_test
    else
      taxons = BiosqlWeb.all_wgs_with_full_taxa
    end
    taxons.each do |hierarchy|
      init_taxons_and_protein_count(hierarchy)
    end
  end

  def protein_count_for(taxon, protein)
    ProteinCount.where(["pfitmap_release_id = ? AND taxon_id = ? AND protein_id = ?", self.id, taxon.id, protein.id])
  end

  def build_gi_ncbi_taxon_hash(gi_taxon_for_all_hits)
    gi_ncbi_taxon_hash = {}
    gi_taxon_for_all_hits.each do |gi_hash|
      ncbi_taxon_id = gi_hash["taxon_with_name"]["ncbi_taxon_id"]
      gi_ncbi_taxon_hash[gi_hash["protein_gi"]] = ncbi_taxon_id
    end
    return gi_ncbi_taxon_hash
  end
  
  private
  def taxon_in_db_lookup(taxon_hash)
    Taxon.find(:first, :conditions => ["ncbi_taxon_id = ?", taxon_hash["ncbi_taxon_id"]])
  end

  def init_taxons_and_protein_count(hierarchy)
    first_taxon, second_taxon, *rest = *hierarchy
    first_taxon_in_db = taxon_in_db_lookup(first_taxon)
    # Make sure this taxon exists and has wgs=true
    taxon = dry_taxon_first(first_taxon, first_taxon_in_db, second_taxon)
    # For each protein, initialize protein_count and/or add 1 to no_genomes
    protein_count_init_or_add(taxon)
    # Rename variable before loop
    current_taxon = second_taxon 
    rest.each do |next_taxon|
      taxon_in_db = taxon_in_db_lookup(current_taxon)
      #Make sure this taxon exist but let wgs be as before
      taxon = dry_taxon(current_taxon, taxon_in_db, next_taxon)
      protein_count_init_or_add(taxon)
      current_taxon = next_taxon
    end
    # The last taxon should also be added:
    taxon_in_db = taxon_in_db_lookup(current_taxon)
    taxon = dry_taxon(current_taxon, taxon_in_db, nil)
    protein_count_init_or_add(taxon)
  end



  def protein_count_init_or_add(taxon)
    proteins = Protein.all
    proteins.each do |protein|
      protein_count = protein_count_for(taxon,protein).first
      if not protein_count
        protein_count = ProteinCount.new(no_genomes: 0, no_proteins: 0, no_genomes_with_proteins: 0)
        protein_count.pfitmap_release_id = self.id
        protein_count.protein_id = protein.id
        protein_count.taxon_id = taxon.id
        protein_count.save
      end
      protein_count.add_genome
    end
  end
  

  def dry_taxon(taxon_hash,taxon_in_db,next_taxon)
    if not taxon_in_db
      taxon_in_db = Taxon.new
      taxon_in_db.ncbi_taxon_id = taxon_hash["ncbi_taxon_id"]
      taxon_in_db.name = taxon_hash["scientific_name"]
      taxon_in_db.rank = taxon_hash["node_rank"]
      if next_taxon
        taxon_in_db.parent_ncbi_id = next_taxon["ncbi_taxon_id"]
      end
      taxon_in_db.save
    else
      taxon_in_db.rank = taxon_hash["node_rank"]
    end
    return taxon_in_db
  end


  def dry_taxon_first(first_taxon_hash,taxon_in_db, next_taxon)
    if taxon_in_db
      taxon_in_db.wgs = "true"
      taxon_in_db.rank = first_taxon_hash["node_rank"]
    else
      taxon_in_db = Taxon.new
      taxon_in_db.ncbi_taxon_id = first_taxon_hash["ncbi_taxon_id"]
      taxon_in_db.name = first_taxon_hash["scientific_name"]
      taxon_in_db.rank = first_taxon_hash["node_rank"]
      taxon_in_db.parent_ncbi_id = next_taxon["ncbi_taxon_id"]
      taxon_in_db.wgs = "true"
    end
    taxon_in_db.save
    return taxon_in_db
  end
end
