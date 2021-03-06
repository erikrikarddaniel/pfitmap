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
    @hmm_profiles = HmmProfile.all.sort! { |p1,p2| p1.hierarchy <=> p2.hierarchy }
    @releases_for_same_source = PfitmapRelease.find_all_by_sequence_source_id(@sequence_source.id)
    @hmm_profiles.each do |profile|
      profile.release_statistics = []
      @releases_for_same_source.each do |release|
        included_count, included_min, included_max = 
          HmmProfileReleaseStatistic.stats_for(profile, @sequence_source, release)
        profile.release_statistics << { :release => release,
          :count => included_count,
          :min_score => included_min,
          :max_score => included_max}
      end

      not_inc_count, not_inc_min, not_inc_max = 
        HmmProfileReleaseStatistic.stats_for(profile, @sequence_source, nil)
      profile.release_statistics << {
        :release => nil, 
        :count => not_inc_count, 
        :min_score => not_inc_min, 
        :max_score => not_inc_max
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
    
    if Rails.env == "test"
      @pfitmap_release.make_current(@current_release)
      respond_to do |format|
        format.html { redirect_to pfitmap_releases_url }
        format.json { head :no_content }
      end
    else
      @pfitmap_release.delay.make_current(@current_release)
      flash[:notice] = "This release will soon be made current."
      respond_to do |format|
        format.html { redirect_to pfitmap_releases_url }
        format.json { head :no_content }
      end
    end
  end

  # POST /calculate/1
  # A method to fill the ProteinCount table
  # Assumes that all proteins are already created
  def calculate
    @pfitmap_release = PfitmapRelease.find(params[:pfitmap_release_id])
    user = current_user
    LoadDatabase.where(active: true).each do |load_db|
      if Rails.env == "test" 
        @pfitmap_release.calculate_released_dbs(load_db)
      elsif Rails.env == "development"
	@pfitmap_release.delay.calculate_released_dbs(load_db)
      else
        @pfitmap_release.delay.calculate_released_dbs(load_db)
      end
    end

    
    respond_to do |format|
      flash[:success] = "The Protein Counts will now be calculated! This will take approx 30 min."
      format.html { redirect_to pfitmap_release_path(@pfitmap_release) }
    end
  end

end
