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
  

  def protein_count_for(taxon, protein)
    ProteinCount.where(["pfitmap_release_id = ? AND taxon_id = ? AND protein_id = ?", self.id, taxon.id, protein.id])
  end

  def calculate_main(user)
    # Resets the protein_counts table for the release and 
    # fills it with new values.
    pfitmap_release = self
    db_string = "ref"

    # Destroy old protein counts rows for this release
    @protein_counts = @pfitmap_release.protein_counts
    @protein_counts.destroy_all

    # Make sure the protein table is filled
    Protein.initialize_proteins

    # Retrieve all whole genome sequenced organisms id
    wgs_ncbi_ids = BiosqlWeb.wgs_ncbi_ids

    # Initialize dry run, count genomes
    dry_run(wgs_ncbi_ids, pfitmap_release)
    
    # Second iteration, count hits
    second_run_count_hits(pfitmap_release)
  end

  private
  def dry_run(wgs_ncbi_ids, pfitmap_release)
    # First iterate over whole genome sequenced organisms
    wgs_ncbi_ids.each do |wgs_ncbi_id|
      taxons = BiosqlWeb.full_taxa_for_ncbi_id(wgs_ncbi_id)
      first_taxon, second_taxon, *rest = *taxons

      # Special case for the leaf node
      first_taxon_in_db = taxon_in_db_lookup(first_taxon)
      # Make sure this taxon exists and has wgs=true
      taxon = init_taxon_first(first_taxon, first_taxon_in_db, second_taxon)
      # For each protein, initialize protein_count and/or add 1 to no_genomes
      protein_count_init_or_add(taxon)
          
      current_taxon = second_taxon 
      
      # Go from leaf to root, in taxonomy tree.
      rest.each do |next_taxon|
        taxon_in_db = taxon_in_db_lookup(current_taxon)
        taxon = init_taxon(current_taxon, taxon_in_db, next_taxon)
        protein_count_init_or_add(taxon)
        current_taxon = next_taxon
      end
          
      # The last taxon should also be added:
      taxon_in_db = taxon_in_db_lookup(current_taxon)
      taxon = dry_taxon(current_taxon, taxon_in_db, nil)
      protein_count_init_or_add(taxon)
    end
  end

  def second_run_count_hits(pfitmap_release)
    # The protein counts table is assumed to be initiated
    # with zeroes and the number of genomes calculated.
    pfitmap_release.pfitmap_sequences do |p_sequence|
      best_profile = p_sequence.hmm_profile
      proteins = best_profile.all_proteins_including_parents
      p_sequence.hmm_db_hits.where("db = ?", db_string).select(:gi).each do |hit|
        taxon_leaves = BiosqlWeb.get_taxons_ncbi_id_by_gi(hit.gi)
        taxon_leaves.each do |taxon_leaf|
          genome_taxon = Taxon.find_by_ncbi_taxon_id(ncbi_taxon_id)
          # CHECK THAT ITS GOLD
          unless genome_taxon.nil? || not genome_taxon.wgs
            taxons = genome_taxon.self_and_ancestors
            proteins.each do |protein|
              ProteinCount.add_hit(protein,taxons,@pfitmap_release)
            end
          end
        end
      end
    end
  
  def taxon_in_db_lookup(taxon_hash)
    Taxon.find(:first, :conditions => ["ncbi_taxon_id = ?", taxon_hash["ncbi_taxon_id"]])
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
  

  def init_taxon(taxon_hash,taxon_in_db,next_taxon)
    if not taxon_in_db
      taxon_in_db = Taxon.new
      taxon_in_db.ncbi_taxon_id = taxon_hash["ncbi_taxon_id"]
      taxon_in_db.name = taxon_hash["scientific_name"]
      taxon_in_db.rank = taxon_hash["node_rank"]
      if next_taxon
        taxon_in_db.parent_ncbi_id = next_taxon["ncbi_taxon_id"]
      end
    else
      taxon_in_db.rank = taxon_hash["node_rank"]
    end
    taxon_in_db.save
    return taxon_in_db
  end


  def init_taxon_first(first_taxon_hash,taxon_in_db, next_taxon)
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
