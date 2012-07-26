class PfitmapReleasesController < ApplicationController
  load_and_authorize_resource
  # GET /pfitmap_releases
  # GET /pfitmap_releases.json
  def index
    @pfitmap_releases = PfitmapRelease.all(order: "release DESC")
    @current_release = PfitmapRelease.find_current_release

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pfitmap_releases }
    end
  end

  # GET /pfitmap_releases/1
  # GET /pfitmap_releases/1.json
  def show
    @pfitmap_release = PfitmapRelease.find(params[:id])
    @sequence_source = @pfitmap_release.sequence_source
    @hmm_profiles = HmmProfile.all
    @hmm_profiles.each do |profile|
      included_count, included_min, included_max = 
        DbSequenceBestProfile.included_stats(profile, @sequence_source)
      not_inc_count, not_inc_min, not_inc_max = 
        DbSequenceBestProfile.not_included_stats(profile, @sequence_source)

      profile.release_statistics = {
        :included => 
        {:count => included_count, 
          :min_score => included_min, 
          :max_score => included_max},
        :not_included =>
        {:count => not_inc_count,
          :min_score => not_inc_min,
          :max_score => not_inc_max}
      }
    end
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pfitmap_release }
    end
  end

  # GET /pfitmap_releases/new
  # GET /pfitmap_releases/new.json
  def new
    @pfitmap_release = PfitmapRelease.new
    @sequence_sources = SequenceSource.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pfitmap_release }
    end
  end

  # GET /pfitmap_releases/1/edit
  def edit
    @pfitmap_release = PfitmapRelease.find(params[:id])
    @sequence_sources = SequenceSource.all
  end

  # POST /pfitmap_releases
  # POST /pfitmap_releases.json
  def create
    @pfitmap_release = PfitmapRelease.new(params[:pfitmap_release])
    @pfitmap_release.current = 'false'
    respond_to do |format|
      if @pfitmap_release.save
        format.html { redirect_to @pfitmap_release, notice: 'Pfitmap release was successfully created.' }
        format.json { render json: @pfitmap_release, status: :created, location: @pfitmap_release }
      else
        @sequence_sources = SequenceSource.all
        format.html { render action: "new" }
        format.json { render json: @pfitmap_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pfitmap_releases/1
  # PUT /pfitmap_releases/1.json
  def update
    @pfitmap_release = PfitmapRelease.find(params[:id])
    if not @pfitmap_release.current
      @pfitmap_release.current = 'false'
    end
    respond_to do |format|
      if @pfitmap_release.update_attributes(params[:pfitmap_release])
        format.html { redirect_to @pfitmap_release, notice: 'Pfitmap release was successfully updated.' }
        format.json { head :no_content }
      else
        @sequence_sources = SequenceSource.all
        format.html { render action: "edit" }
        format.json { render json: @pfitmap_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pfitmap_releases/1
  # DELETE /pfitmap_releases/1.json
  def destroy
    @pfitmap_release = PfitmapRelease.find(params[:id])
    @pfitmap_release.destroy

    respond_to do |format|
      format.html { redirect_to pfitmap_releases_url }
      format.json { head :no_content }
    end
  end
  
  # POST /make_current/1
  def make_current
    @pfitmap_release = PfitmapRelease.find(params[:pfitmap_release_id])
    @current_release = PfitmapRelease.find_current_release
    
    if @current_release != @pfitmap_release
      if @current_release
        @current_release.current = false
        @current_release.save
      end

      @pfitmap_release.current = true
      @pfitmap_release.save
    end
    
    respond_to do |format|
      format.html { redirect_to pfitmap_releases_url }
      format.json { head :no_content }
    end
  end

  # POST /calculate/1
  # A method to fill the ProteinCount table
  # Assumes that all proteins are already created
  def calculate
    begin
      @pfitmap_release = PfitmapRelease.find(params[:pfitmap_release_id])
      @pfitmap_sequences = @pfitmap_release.pfitmap_sequences

      # Get all hmm_db_hits and its taxons
      gi_taxon_for_included_hits = HmmDbHit.all_taxons_for(@pfitmap_release)

      # Build a hash with gi as keys and ncbi_taxon_id as values 
      ncbi_gi_taxon_hash = @pfitmap_release.build_gi_ncbi_taxon_hash(gi_taxon_for_included_hits)

      # Destroy old protein counts rows for this release
      @protein_counts = @pfitmap_release.protein_counts
      @protein_counts.destroy_all
      
      # Make sure the protein table is filled
      Protein.initialize_proteins

      # Fill the taxon table and dry run for the protein_counts
      @pfitmap_release.protein_counts_initialize_dry
      
      # Iterate over the sequences and populate protein counts for each
      # protein and taxon. 
      @pfitmap_sequences.each do |seq|
        seq.calculate_counts(@pfitmap_release, ncbi_gi_taxon_hash)
      end
    rescue
      logger.debug "#{__FILE__}"
      logger.debug "blablabla This is the error: #{$!}"
      respond_to do |format|
        flash[:error] = "Some error has occured, please check the log for more details"
        format.html { redirect_to pfitmap_release_path(@pfitmap_release) }
      end
    else
      respond_to do |format|
        flash[:success] = "The ProteinCount table was calculated successfully"
        format.html { redirect_to pfitmap_release_path(@pfitmap_release) }
      end
    end
  end
end
