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
    @sequences = @pfitmap_release.db_sequences
    
    #Set virtual attribute hmm_profile
    #Store the result of the possibly heavy operation "best_hmm_profile"

    @sequences.each do |seq|
      seq.hmm_profile, seq.score = seq.best_hmm_profile_with_score
    end
    
    #Create instance variable @profiles_with_sequences containing
    #an array of pairs [profile_id,[sequences_for_that_profile]]
    @profiles_with_sequences = @sequences.group_by { |a| a.hmm_profile }
    
    @profiles_with_statistics = @profiles_with_sequences.map do |pair|
      profile = HmmProfile.find(pair[0])
      seq_arr = pair[1]
      seq_count = seq_arr.count
      min_score = seq_arr.min { |a,b| a.score <=> b.score }.score
      max_score = seq_arr.max { |a,b| a.score <=> b.score }.score
      [profile, [seq_count,min_score, max_score]]
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pfitmap_release }
    end
  end

  # GET /pfitmap_releases/1/edit
  def edit
    @pfitmap_release = PfitmapRelease.find(params[:id])
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
        format.html { render action: "new" }
        format.json { render json: @pfitmap_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pfitmap_releases/1
  # PUT /pfitmap_releases/1.json
  def update
    @pfitmap_release = PfitmapRelease.find(params[:id])

    respond_to do |format|
      if @pfitmap_release.update_attributes(params[:pfitmap_release])
        format.html { redirect_to @pfitmap_release, notice: 'Pfitmap release was successfully updated.' }
        format.json { head :no_content }
      else
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
end
