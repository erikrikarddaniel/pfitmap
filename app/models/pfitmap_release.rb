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

  def calculate_main(organism_group, user)
    PfitmapRelease.transaction do
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

      calculate_logger.info "#{Time.now} Started calculate_main."

      require "matrix"

      # Resets the protein_counts table for the release and 
      # fills it with new values.
      pfitmap_release = self
      db_string = "ref"

      # Accepted ranks
      rank_hash = {}
      Taxon::RANKS.each do |r|
	rank_hash[r] = true
      end 
      # Destroy old protein counts rows for this release
      ProteinCount.delete_all(["pfitmap_release_id = ?",pfitmap_release.id])
      calculate_logger.info "#{Time.now} Deleted old protein_counts for this release."

      # Make sure the protein table is filled
      Protein.initialize_proteins
      proteins = Protein.all
      calculate_logger.info "#{Time.now} Initialized proteins."

      # Retrieve all whole genome sequenced organisms id
      taxon_ncbi_ids = BiosqlWeb.organism_group2ncbi_taxon_ids(organism_group)
      calculate_logger.info "#{Time.now} Collected organism groups' NCBI taxon ids from biosql."

      # Initialize dry run, count genomes
      tree = dry_run(taxon_ncbi_ids, pfitmap_release, proteins, rank_hash)
      calculate_logger.info "#{Time.now} Dry run finished."

      # Second iteration, count hits
      second_run_count_hits(tree, pfitmap_release,db_string)
      calculate_logger.info "#{Time.now} Second_run_count_hits finished."

      # Save tree to database
      save_pc_to_db(tree)
      calculate_logger.info "#{Time.now} Everything finished, saved protein counts to db.\n"
    end
  rescue => e
    calculate_logger.error "#{Time.now} Calculate failed: .\n"+e.message
    raise "Failed calculate"
    
  end

  def calculate_logger
    @@calculate_logger ||= ActiveSupport::BufferedLogger.new(Rails.root.join('log/calculate.log'))
  end

  private
  def dry_run(taxon_ncbi_ids, pfitmap_release, proteins, rank_hash)
    ## Dry run of the calculate_main method
    #  Pulls taxon hierarchies from biosqlweb and adds 1 to no_genomes attribute 
    #  that it is marked with wgs = true. 
    #  For all taxons, it visits (or initializes) all its protein_counts and 
    #  adds 1 to the no_genomes attribute.

    # Tree structure for protein_counts
    # {taxon_ncbi_id => [taxon_names, {protein_id => protein_count_vector}]}
    tree = {}
    # First iterate over whole genome sequenced organisms
    taxons_list = BiosqlWeb.ncbi_taxon_ids2full_taxon_hierarchies(taxon_ncbi_ids)
    taxons_list.zip(taxon_ncbi_ids).each do |taxons,ncbi|
      hierarchy_name_list = hierarchy_names(taxons, rank_hash)
      pv_hash = {}
      proteins.each { |p| pv_hash[p.id] = Vector[1,0,0] }
      tree[ncbi] = [hierarchy_name_list,pv_hash]
    end
    return tree
  rescue => e
    calculate_logger.error "#{Time.now} dry run failed. Error: .\n"+e.message
    raise "Failed dry run"
  end
      


  def second_run_count_hits(tree, pfitmap_release, db_string)
    # To be called after the dry_run method. 
    # Iterates over all pfitmap_sequences and collects the corresponding
    # taxon through biosqlweb. It thereby iterates upwards through
    # the taxon hierarchy and adds 1 to the no_proteins for all.
    # If the taxon leaf has no protein hit before, then also adds
    # 1 to no_genomes_with_proteins to all taxons up to root.
    
    # Add combinations of taxons and proteins where it has been observed
    # {taxon_id => { protein_id => true }}
    obs_as_genome = {}
    pfitmap_release.pfitmap_sequences.each do |p_sequence|
      best_profile = p_sequence.hmm_profile
      proteins = best_profile.all_proteins_including_parents
      p_sequence.db_entries.where("db = ?", db_string).select(:gi).each do |entry|
        ncbi_taxon_id = BiosqlWeb.gi2ncbi_taxon_id(entry.gi)
        tree_item = tree[ncbi_taxon_id]

        unless tree_item.nil? || (not tree_item.last) # Valid taxon to hit?
          protein_vector_hash = {}
          proteins.each do |p|
            # Is this protein-taxon combo observed as genome before?
            if obs_as_genome[ncbi_taxon_id] and obs_as_genome[ncbi_taxon_id][p.id]
              protein_vector_hash[p.id] = Vector[0,1,0]
            else 
              if (not obs_as_genome[ncbi_taxon_id])
                obs_as_genome[ncbi_taxon_id] = {}
              end
              protein_vector_hash[p.id] = Vector[0,1,1]
              obs_as_genome[ncbi_taxon_id][p.id] = true
            end
          end
          add_pc(tree, ncbi_taxon_id, protein_vector_hash)
        end
      end
    end
  rescue => e
    calculate_logger.error "#{Time.now} second run failed: .\n"+e.message
    raise "Failed second run"
  end

  def save_pc_to_db(tree)
    tree.each do |ncbi_id,value_list|
      taxon = value_list[0]
      protein_pc_hash = value_list[1]
      taxon_id = save_taxon(taxon,ncbi_id)
      protein_counts = []
      protein_pc_hash.each do |protein, vec|
        protein_counts << save_protein_count(protein, taxon_id, vec)
      end
      ProteinCount.import protein_counts
    end
  rescue => e
    calculate_logger.error "#{Time.now} save pc to db failed: .\n"+e.message
    raise "Failed save pc to db"
  end

  def save_to_db(tree)
    tree.each do |ncbi_id, value_list|
      parent_ncbi_id = value_list ? value_list[0] : nil
      taxon = value_list[1]
      protein_pc_hash = value_list[2]
      taxon_id = save_taxon(taxon,parent_ncbi_id)
      protein_counts = []
      protein_pc_hash.each do |protein, vec|
        protein_counts << save_protein_count(protein, taxon_id, vec)
      end
      ProteinCount.import protein_counts
    end 
  rescue => e
    calculate_logger.error "#{Time.now} save to db failed: .\n"+e.message
    raise "Failed save to db"
  end
  def add_pc(tree, ncbi_id, pv_hash)
    protein_hash = tree[ncbi_id][1]
    pv_hash.each do |p,v|
      protein_hash[p] += v
    end
  rescue => e
    calculate_logger.error "#{Time.now} add pc failed: .\n"+e.message
    raise "Failed add pc"
  end

  def add_pc_recursively(tree, ncbi_id, pv_hash, first)
    if tree[ncbi_id] and ncbi_id
      # Checkbox for taxons included in organism group
      if first and (not tree[ncbi_id][3])
	tree[ncbi_id][3] == true
      end
	      protein_hash = tree[ncbi_id][2]
      pv_hash.each do |p,v|
	protein_hash[p] += v
      end
      add_pc_recursively(tree, tree[ncbi_id].first, pv_hash, false)
    else
      return tree
    end
  rescue => e
    calculate_logger.error "#{Time.now} add pc recursively failed: .\n"+e.message
    raise "Failed add pc recursively"
  end

  def new_taxon_to_tree(tree, taxon_hash, parent_taxon_hash, proteins, first, hierarchy)
    p_hash = {}
    proteins.each do |p|
      p_hash[p.id] = Vector[1,0,0]
    end
    taxon_id = taxon_hash["ncbi_taxon_id"]
    hierarchy_string = hierarchy.join(":").gsub(/\s+/, "")
    taxon_hash["hierarchy"] = hierarchy_string
    parent_id = parent_taxon_hash ? parent_taxon_hash["ncbi_taxon_id"] : nil
    tree[taxon_id] = [parent_id, taxon_hash, p_hash, first]
    
  rescue => e
    calculate_logger.error "#{Time.now} new taxon to tree failed: .\n"+e.message
    raise "Failed new taxon to tree"
  end

  def hierarchy_names(taxons, rank_hash)
    # Returns a list with values for each hierarchy column in Taxon
    # Some taxons-lists will be an html-error page
    begin
      name_hash = Hash[Taxon::RANKS.map{ |r| [r,nil]}]
      name_hash["strain"] = nil
      # Filter on accepted ranks, re-add first and root
      accepted_taxons = taxons.select {|taxon_hash| taxon_hash["node_rank"].in?(rank_hash)}
      accepted_taxons.each do |at|
	rank = at['node_rank']
	name = at['scientific_name']
	if rank.in?(name_hash)
	  name_hash[rank] = name
	end
      end
      # if the lowest level in the taxon hierarchy is not used, add it as strain if strain not used already
      if not taxons.first.in?(accepted_taxons)
	if not name_hash['strain']
	  name_hash['strain'] = taxons.first['scientific_name']
	else
	  calculate_logger.error "#{Time.now} Error, strain was already in use so the lowest taxon not added: #{taxons.first['ncbi_taxon_id']}"
	end
      end
      # If kingdom is missing, use the taxon below superkingdom as kingdom (if it has
      # not already been used 
      if not "kingdom".in?(accepted_taxons.map {|t| t['node_rank']})
	#Pick out the index of super kingdom and go down the hierarchy by one
	kingdom = taxons[taxons.find_index {|t| t['node_rank'] =="superkingdom" } - 1]
	#If the taxon picked out already in the accepted list, don't use it again
	if not kingdom.in?(accepted_taxons)
	  name_hash["kingdom"] = kingdom['scientific_name']
	else
	  calculate_logger.error "#{Time.now} Error, kingdom was missing, and the first level below superkingdom was already used: #{taxons.first['ncbi_taxon_id']}"
	end
      end
      #Make missing taxas names unique: Each taxa below domain takes its parents name plus no level. So if kingdom of Bacteria is nil we get: "kingdom" => "Bacteria, no kingdom"
      Taxon::RANKS[1..-1].each_with_index do |r,i|
        if not name_hash[r]
          name_hash[r] = "#{name_hash[Taxon::RANKS[i]]}, no #{r}"
        end
      end
      #Top level should be called domain, not superkingdom
      name_hash["domain"] = name_hash["superkingdom"]
      name_hash.delete "superkingdom"
      # Pick out the names
      return [name_hash['domain'],name_hash['kingdom'],name_hash['phylum'],name_hash['class'],name_hash['order'],name_hash['family'],name_hash['genus'],name_hash['species'],name_hash['strain']]
    rescue
      []
    end
  rescue => e
    calculate_logger.error "#{Time.now} hierarcy names failed: .\n"+e.message
    raise "Failed hierarcy names"
  end

  def save_taxon(taxon_hash,ncbi_taxon_id)
    taxon_in_db = Taxon.find_by_ncbi_taxon_id(ncbi_taxon_id)
    if taxon_in_db
      taxon = taxon_in_db
    else
      taxon = Taxon.new
    end
    taxon.ncbi_taxon_id = ncbi_taxon_id
    taxon.pfitmap_release_id = self.id
    ["domain","kingdom","phylum","taxclass","taxorder","family","genus","species","strain"].zip(taxon_hash).map {|ta,ha| taxon[ta] = ha}
    taxon.save
    return taxon.id
  rescue => e
    calculate_logger.error "#{Time.now} save taxon failed: .\n"+e.message
    raise "Failed save taxon"
  end

  def save_protein_count(protein_id, taxon_id, vec)
    protein_count = ProteinCount.new(no_proteins: vec[1], 
                                     no_genomes_with_proteins: vec[2])
    protein_count.pfitmap_release_id = self.id
    protein_count.protein_id = protein_id
    protein_count.taxon_id = taxon_id
    return protein_count
  rescue => e
    calculate_logger.error "#{Time.now} save protein count failed: .\n"+e.message
    raise "Failed save proave protein count"
  end
end
