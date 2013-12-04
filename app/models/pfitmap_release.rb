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
  HTTP_TIMEOUT = 6000
  SLICE_SIZE = 5000

  attr_accessible :release, :release_date, :sequence_source_id
  has_many :pfitmap_sequences, :dependent => :destroy
  has_many :db_sequences, :through => :pfitmap_sequences
  has_many :db_entries, :through => :db_sequences
  has_many :taxons
  has_many :protein_counts
  has_many :hmm_profile_release_statistics
  belongs_to :sequence_source
  validates :release, :presence => :true
  validates :release_date, :presence => :true
  validates_inclusion_of :current, :in => [true, false]
  validates :sequence_source_id, :presence => :true, :uniqueness => :true

  def to_s
    "PfitmapRelease: #{release}"
  end

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
      PfitmapSequence.create(db_sequence_id: db_seq.id, pfitmap_release_id: self.id, hmm_profile_id: hmm_profile.id)
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

  def calculate_logger
    @@calculate_logger ||= ActiveSupport::BufferedLogger.new(Rails.root.join('log/calculate.log'))
  end

  def calculate_released_dbs(load_db)
    ## Calculate_main populates the protein_counts table with statistics:
    #  There exists one row in protein_counts table for each combination of
    #  taxon, protein and pfitmap_release (if it has been "calculated").
    #  protein_counts row contains three values and one boolean:
    #    - no_genomes
    #    - no_proteins
    #    - no_genomes_with_proteins
    #    - obs_as_genome
    #  See app/model/protein_count.rb for further information
    #  
    # The steps of the algorithm are explained below.

    calculate_logger.info "#{Time.now}: Started calculate_released_db(#{load_db})"

    require "matrix"

    calculate_logger.info "#{Time.now}: Loading #{load_db.name}"
    PfitmapRelease.transaction do
      calculate_logger.info "#{Time.now}: Create released db"
      released_db = create_released_db(load_db)

      # Fetch all pfitmap_sequence objects for this release and its db_entries for the database selected
      # when calling pfitmap_sequences.db_entries we get only the entries with db = load_db.sequence_database.db
      calculate_logger.info "#{Time.now}: Fetching pfitmap_sequence objects"

      pfitmap_sequences = PfitmapSequence.find(:all, include: [:db_entries,:hmm_profile], conditions: {pfitmap_release_id: self.id, db_entries: {db: load_db.sequence_database.db}})
      gis = Set.new(pfitmap_sequences.map {|p| p.db_entries.map {|d| d.gi}.flatten}.flatten)
	
      calculate_logger.info "#{Time.now}: Fetched #{gis.length} gis"

      # Fetch and load all taxa, implement as method, return hash
      calculate_logger.info "#{Time.now}: Creating taxon mapping"
      taxon_map = save_and_fetch_taxonset(load_db.taxonset, gis, released_db)
      calculate_logger.info "#{Time.now}: Created #{taxon_map.length} taxon maps"
        
      # Create protein records, store in hash: gi -> protein.id
      calculate_logger.info "#{Time.now}: Creating protein mapping"
      protein_map = save_and_fetch_proteins(pfitmap_sequences,released_db)
      calculate_logger.info "#{Time.now}: Created #{protein_map.length} protein maps"

      # Fetch all gi -> ncbi_taxon_id, count and batch insert
      protein_counts = {}
        
      calculate_logger.info "#{Time.now}: Getting ncbi taxon ids from gis"
      gis2tids = BiosqlWeb.gis2ncbi_taxon_ids(gis)
      calculate_logger.info "#{Time.now}: Fetched #{gis2tids.length} ncbi taxon ids maps"

      calculate_logger.info "#{Time.now}: Generating protein counts"
      gis2tids.each do |gi2tid|
        gi = gi2tid["protein_gi"]
        tid = gi2tid["taxon_id"]

	# It happens that no taxon_id is returned for a gi, warn and continue 
	# with the next entry
        unless taxon_map[tid]
          calculate_logger.warn "#{Time.now}: Found no taxon for gi: #{gi}, tid: #{tid}"
          next
        end
        unless protein_map[gi]
          calculate_logger.warn "#{Time.now}: Found no protein for gi: #{gi}, tid: #{tid}"
        next
        end
        unless protein_counts[protein_map[gi]]
          protein_counts[protein_map[gi]] = {}
        end
        unless protein_counts[protein_map[gi]][tid]
          protein_counts[protein_map[gi]][tid] = ProteinCount.new(
            released_db_id: released_db.id,
            taxon_id: taxon_map[tid],
            protein_id: protein_map[gi],
            no_proteins: 0,
            no_genomes_with_proteins: 1
          )
        end
        protein_counts[protein_map[gi]][tid].no_proteins += 1
      end

      calculate_logger.info "#{Time.now}: Bulk importing #{protein_counts.length} protein counts"

      ProteinCount.import protein_counts.values.map { |pc| pc.values }.flatten

      calculate_logger.info "#{Time.now}: Created protein counts"
    end

    calculate_logger.info "#{Time.now}: Finished calculate_released_db(#{load_db})"
  rescue => e
    calculate_logger.error "#{Time.now}: Calculate FAILED for #{load_db.name} with error: #{e}"
    raise e
  end

  def create_released_db(load_db)
    # Delete old taxon, protein_count and protein rows
    # (Don't forget to implement cascading delete in taxon, protein and protein_count.)
    released_db = ReleasedDb.find(:first, conditions: {pfitmap_release_id: self, load_database_id: load_db})
    released_db.destroy if released_db
    # Insert released_db
    released_db = ReleasedDb.new
    released_db.pfitmap_release = self
    released_db.load_database = load_db
    released_db.save
    released_db
  end


  # Inserts a list of unique taxons, fetched via the url in taxonseturl
  # and a list of gis. Returns a map from ncbi_taxon_id -> taxon.id.
  def save_and_fetch_taxonset(taxonseturl, gis, released_db)
    taxon_map = {}

    calculate_logger.info "#{Time.now}: Fetching json taxa"

    slicei = 0
    imported = {}
    gis.to_a.each_slice(SLICE_SIZE) do |gislice|
      taxon_names = []
      calculate_logger.info "#{Time.now}: Fetching slice #{slicei += 1} (slice size: #{SLICE_SIZE})"

      options = {
	headers: {
	  'Content-Type' => 'application/json',
	  'Accepts' => 'application/json' },
	body: { gis: gislice }.to_json,
	timeout: HTTP_TIMEOUT
      }
      json_taxa = {}
      begin
	response = HTTParty.get(taxonseturl, options)
	json_taxa = response.parsed_response
      rescue
	calculate_logger.error "#{Time.now}: Error fetching slice #{slicei}: #{$!}"
	throw $!
      end

      calculate_logger.info "#{Time.now}: Fetched #{json_taxa.length} taxa"

      json_taxa.each do |taxon|
	next if imported[taxon[0]["ncbi_taxon_id"]]
	taxon_names << generate_taxons_names(taxon, released_db)
	imported[taxon[0]["ncbi_taxon_id"]] = true
      end

      calculate_logger.info "#{Time.now}: Bulk importing #{taxon_names.length} taxa"

      # Bulk insert the taxons with released_db_id
      Taxon.import taxon_names
    end

    Taxon.where(released_db_id: released_db.id).each do |taxon|
      taxon_map[taxon.ncbi_taxon_id] = taxon.id
    end

    calculate_logger.info "#{Time.now}: Created #{taxon_map.length} taxa"
    taxon_map
  end

  # Inserts a list of unique proteins and returns a
  # hash with a map from gi to protein.id
  def save_and_fetch_proteins(pfitmap_sequences, released_db)
    protein_map = {}
    # Save all distinct proteins
    hpid2proteinids = {}

    calculate_logger.info "#{Time.now}: Getting unique hmm profiles"
    hmm_p = Set.new(pfitmap_sequences.map { |p| p.hmm_profile })
    calculate_logger.info "#{Time.now}: Found #{hmm_p.length} hmm profiles"

    calculate_logger.info "#{Time.now}: Creating proteins"
    hmm_p.each do |hp|
      hpid2proteinids[hp.id] =
        Protein.create(generate_protein_names(hp, released_db)).id
    end
    calculate_logger.info "#{Time.now}: Created" +
      " #{hpid2proteinids.length} proteins"
    # Create map from pfitmap_sequence...gi to its protein.id
    pfitmap_sequences.each do |ps|
      # The pfitmap_sequences should have filtered correct
      # db_entries before being sent here.
      ps.db_entries.each do |de|
        protein_map[de.gi] = hpid2proteinids[ps.hmm_profile.id]
      end
    end
    calculate_logger.info "#{Time.now}: Mapped " +
      "#{protein_map.length} db entries gis to protein id"
    protein_map
  end

  def generate_protein_names(hmm_profile, released_db)
    protein_names =
      hmm_profile.all_parents_with_acceptable_rank_including_self.map do |h|
        h.protein_name
      end.reverse!
    protein_hash = Hash[Protein::PROT_COLUMNS.zip(protein_names)]
    protein_hash[:released_db_id] = released_db.id
    protein_hash
  end

  def generate_taxons_names(taxons, released_db)
    name_hash = Hash[Taxon::RANKS.map { |r| [r, nil] }]
    name_hash['strain'] = nil

    # Filter on accepted ranks, re-add first and root
    accepted_taxons = taxons.select do |taxon_hash|
      taxon_hash['node_rank'].in?(Taxon::RANKS)
    end

    accepted_taxons.each do |at|
      rank = at['node_rank']
      name = at['scientific_name']
      name_hash[rank] = name if rank.in?(name_hash)
    end

    # if the lowest level in the taxon hierarchy is not used, add it as
    # strain if strain not used already
    unless taxons.first.in?(accepted_taxons)
      if name_hash['strain']
        calculate_logger.error "#{Time.now} Error, strain was already in" +
          "use so the lowest taxon not added: #{taxons.first['ncbi_taxon_id']}"
      else
        name_hash['strain'] = taxons.first['scientific_name']
      end
    end

    # If kingdom is missing, use the taxon below superkingdom as kingdom
    # (if it has not already been used
    unless 'kingdom'.in?(accepted_taxons.map { |t| t['node_rank'] })
      # Pick out the index of super kingdom and go down the hierarchy by one
      kingdom =
        taxons[taxons.find_index { |t| t['node_rank'] == 'superkingdom' } - 1]

      # If the taxon picked out already in the accepted list, don't use it again
      unless kingdom.in?(accepted_taxons)
        name_hash['kingdom'] = kingdom['scientific_name']
      end
    end

    # Make missing taxon names unique: Each taxon below domain takes its parents
    # name plus no level. So if kingdom of Bacteria is nil we get:
    # "kingdom" => "Bacteria, no kingdom"
    Taxon::RANKS[1..-1].each_with_index do |r, i|
      unless name_hash[r]
        name_hash[r] = "#{name_hash[Taxon::RANKS[i]]}, no #{r}"
      end
    end

    # Top level should be called domain, not superkingdom
    name_hash['domain'] = name_hash['superkingdom']
    name_hash.delete 'superkingdom'

    # Pick out the names
    Taxon.new(
      released_db_id: released_db.id,
      ncbi_taxon_id: taxons.first['ncbi_taxon_id'],
      domain: name_hash['domain'],
      kingdom: name_hash['kingdom'],
      phylum: name_hash['phylum'],
      taxclass: name_hash['class'],
      taxorder: name_hash['order'],
      taxfamily: name_hash['taxfamily'],
      genus: name_hash['genus'],
      species: name_hash['species'],
      strain: name_hash['strain']
    )
  end
end
