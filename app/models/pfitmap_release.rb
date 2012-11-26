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
    rank_hash = {"superkingdom" => true, "phylum" => true, 
      "class" => true, "order" => true, "family" => true,
      "genus" => true, "species" => true }
    
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
    save_to_db(tree)
    calculate_logger.info "#{Time.now} Everything finished, saved protein counts to db.\n"
  end

  def calculate_logger
    @@calculate_logger ||= ActiveSupport::BufferedLogger.new(Rails.root.join('log/calculate.log'))
  end

  private
  def dry_run(taxon_ncbi_ids, pfitmap_release, proteins, rank_hash)
    ## Dry run of the calculate_main method
    #  Pulls one taxon hierarchy from biosqlweb at a time and iteratively
    #  adds taxons that are either 
    #      a) from ranks in rank_hash
    #      b) The leaf for that hierarchy
    #      c) The node named "root"
    #  If the taxon is the leaf node for that hieararchy, it also makes sure 
    #  that it is marked with wgs = true. 
    #  For all taxons, it visits (or initializes) all its protein_counts and 
    #  adds 1 to the no_genomes attribute.

    # Tree structure for protein_counts
    # {taxon_ncbi_id => [parent_ncbi_id, taxon_hash, {protein_id => protein_count_vector}]}
    tree = {}
    # First iterate over whole genome sequenced organisms
    taxon_ncbi_ids.each do |ncbi_taxon_id|
      taxons = BiosqlWeb.ncbi_taxon_id2full_taxon_hierarchy(ncbi_taxon_id)
      hierarchy_name_list = hierarchy_names(taxons, rank_hash)
      # Special case for the leaf node
      first = true
      current_taxon, *rest = *taxons
      rest += [nil] # So that the last taxon also is added
      rest.each do |next_taxon|
        if next_taxon and
            not rank_hash[next_taxon["node_rank"]] and
            not next_taxon["scientific_name"] == "root"
          next
        end

        if tree[current_taxon["ncbi_taxon_id"]]
          pv_hash = {}
          proteins.each { |p| pv_hash[p.id] = Vector[1,0,0] }
          add_pc_recursively(tree, current_taxon["ncbi_taxon_id"], pv_hash, first)
          break
        elsif current_taxon["ncbi_taxon_id"]
          new_taxon_to_tree(tree, current_taxon, next_taxon, proteins, first, hierarchy_name_list)
          hierarchy_name_list.pop
          current_taxon = next_taxon
          first = false
        else
          calculate_logger.error "#{Time.now} Error, could not add taxon with taxon_ncbi_id: #{ncbi_taxon_id}"
        end
      end
    end
    return tree
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
      p_sequence.hmm_db_hits.where("db = ?", db_string).select(:gi).each do |hit|
        ncbi_taxon_id = BiosqlWeb.gi2ncbi_taxon_id(hit.gi)
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
          add_pc_recursively(tree, ncbi_taxon_id, protein_vector_hash, false)
        end
      end
    end
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
    
  end

  def hierarchy_names(taxons, rank_hash)
    # Some taxons-lists will be an html-error page
    begin
      # Filter on accepted ranks, re-add first and root
      accepted_taxons = taxons.select {|taxon_hash| rank_hash[taxon_hash["node_rank"]]}
      if not rank_hash[taxons.first["node_rank"]]
        accepted_taxons.unshift(taxons.first)
      end
      accepted_taxons << taxons.last
      # Pick out the names
      name_list = accepted_taxons.map { |taxon_hash| taxon_hash["scientific_name"] }
      return name_list.reverse
    rescue
      []
    end
  end

  def save_taxon(taxon_hash, parent_taxon_id)
    taxon_in_db = Taxon.find_by_ncbi_taxon_id(taxon_hash["ncbi_taxon_id"])
    if taxon_in_db
      taxon = taxon_in_db
    else
      taxon = Taxon.new
    end
    taxon.ncbi_taxon_id = taxon_hash["ncbi_taxon_id"]
    taxon.name = taxon_hash["scientific_name"]
    taxon.rank = taxon_hash["node_rank"]
    taxon.hierarchy = taxon_hash["hierarchy"]
    taxon.parent_ncbi_id = parent_taxon_id
    taxon.save
    return taxon.id
  end

  def save_protein_count(protein_id, taxon_id, vec)
    protein_count = ProteinCount.new(no_genomes: vec[0], 
                                     no_proteins: vec[1], 
                                     no_genomes_with_proteins: vec[2])
    protein_count.pfitmap_release_id = self.id
    protein_count.protein_id = protein_id
    protein_count.taxon_id = taxon_id
    return protein_count
  end
end
