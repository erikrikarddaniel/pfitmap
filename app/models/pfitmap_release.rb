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


  # Should only be called when there exists a head release
  def add_seq(db_seq, hmm_profile)
    if not self.db_sequences.find_by_id(db_seq.id)
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
    pr = self
    taxons = BiosqlWeb.all_wgs_with_full_taxa
    taxons.each do |hierarchy|
      first_taxon, *rest = *hierarchy
      first_taxon_in_db = taxon_in_db_lookup(first_taxon)
      # Make sure this taxon exists and has wgs=true
      taxon = dry_taxon_first(first_taxon, first_taxon_in_db)
      # For each protein, initialize protein_count and/or add 1 to no_genomes
      protein_count_init_or_add(taxon)
      rest.each do |taxon|
        taxon_in_db = taxon_in_db_lookup(taxon)
        #Make sure this taxon exist but let wgs be as before
        taxon = dry_taxon(taxon, taxon_in_db)
        protein_count_init_or_add(taxon)
      end
    end
  end

  def protein_count_for(taxon, protein)
    ProteinCount.where(["pfitmap_release_id = ? AND taxon_id = ?", self.id, taxon.id])
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
    Taxon.find(:first, :conditions => ["ncbi_taxon_id = ? AND pfitmap_release_id = ?", taxon_hash["ncbi_taxon_id"], self.id])
  end

  def protein_count_init_or_add(taxon)
    proteins = Protein.all
    proteins.each do |protein|
      protein_count = protein_count_for(taxon,protein)
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
  

  def dry_taxon(taxon_hash,taxon_in_db)
    how to add the parents into the taxon
    if not taxon_in_db
      taxon_in_db = Taxon.new
      taxon_in_db.ncbi_taxon_id = taxon_hash["ncbi_taxon_id"]
      taxon_in_db.name = taxon_hash["scientific_name"]
      taxon_in_db.rank = taxon_hash["rank"]
      taxon_in_db.pfitmap_release_id = self.id
      taxon_in_db.save
    end
    return taxon_in_db
  end


  def dry_taxon_first(first_taxon_hash,taxon_in_db)
    if taxon_in_db
      taxon_in_db.wgs = "true"
    else
      taxon_in_db = Taxon.new
      taxon_in_db.ncbi_taxon_id = first_taxon_hash["ncbi_taxon_id"]
      taxon_in_db.name = first_taxon_hash["scientific_name"]
      taxon_in_db.rank = first_taxon_hash["rank"]
      taxon_in_db.wgs = "true"
      taxon_in_db.pfitmap_release_id = self.id
    end
    taxon_in_db.save
    return taxon_in_db
  end
end
