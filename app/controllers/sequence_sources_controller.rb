class SequenceSourcesController < ApplicationController
  load_and_authorize_resource
  # GET /sequence_sources
  # GET /sequence_sources.json
  def index
    @sequence_sources = SequenceSource.all.sort_by{ |s| s.version }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sequence_sources }
    end
  end

  # GET /sequence_sources/1
  # GET /sequence_sources/1.json
  def show
    @sequence_source = SequenceSource.find(params[:id])
    @hmm_results = @sequence_source.hmm_results
    @hmm_profiles_last_parents = HmmProfile.last_parents.sort_by{|p| p.hierarchy }
    @pfitmap_releases = PfitmapRelease.find_all_after_current.map{|rel| [rel.release, rel.id]}
    @hmm_profiles = @sequence_source.hmm_profiles.paginate(page: params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sequence_source }
    end
  end

  # GET /sequence_sources/new
  # GET /sequence_sources/new.json
  def new
    @sequence_source = SequenceSource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sequence_source }
    end
  end

  # GET /sequence_sources/1/edit
  def edit
    @sequence_source = SequenceSource.find(params[:id])
  end

  # POST /sequence_sources
  # POST /sequence_sources.json
  def create
    @sequence_source = SequenceSource.new(params[:sequence_source])

    respond_to do |format|
      if @sequence_source.save
        format.html { redirect_to @sequence_source, notice: 'Sequence source was successfully created.' }
        format.json { render json: @sequence_source, status: :created, location: @sequence_source }
      else
        format.html { render action: "new" }
        format.json { render json: @sequence_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sequence_sources/1
  # PUT /sequence_sources/1.json
  def update
    @sequence_source = SequenceSource.find(params[:id])

    respond_to do |format|
      if @sequence_source.update_attributes(params[:sequence_source])
        format.html { redirect_to @sequence_source, notice: 'Sequence db was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sequence_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequence_sources/1
  # DELETE /sequence_sources/1.json
  def destroy
    @sequence_source = SequenceSource.find(params[:id])
    @sequence_source.destroy

    respond_to do |format|
      format.html { redirect_to sequence_sources_url }
      format.json { head :no_content }
    end
  end

  # POST /sequence_sources/1/evaluate
  # POST /sequence_sources1/evaluate.json ???

  def evaluate
    logger.info "Starting evaluate"
    @sequence_source = SequenceSource.find(params[:sequence_source_id])
    @head_release = @sequence_source.pfitmap_release
    user = current_user
    
    if (@head_release and @sequence_source)
      logger.info "Found the sequence_source and the head_release"
      PfitmapSequence.delete_all(["pfitmap_release_id = ?", @head_release.id])
      logger.info "Destroyed all related pfitmap_sequences"

      @head_release.sequence_source_id = @sequence_source.id
      @head_release.save
      if Rails.env == "test"
        @sequence_source.evaluate(@head_release, user)
        
        flash[:success] = 'This sequence source was successfully evaluated.'
        respond_to do |format|
          format.html { redirect_to @sequence_source }
          format.json { head :no_content }
        end

      else
        @sequence_source.delay.evaluate(@head_release, user)
      
        flash[:success] = 'Evaluating, this may take some time.'
        respond_to do |format|
          format.html { redirect_to @sequence_source }
          format.json { head :no_content }
        end
      end
    else
      @hmm_results = @sequence_source.hmm_results.paginate(page: params[:page])
      @hmm_profiles_last_parents = HmmProfile.last_parents.sort_by{|p| p.hierarchy }
      @hmm_profiles = @sequence_source.hmm_profiles
      @pfitmap_releases = PfitmapRelease.find_all_after_current.map{|rel| [rel.release, rel.id]}

      flash.now[:error] = 'There is no current Pfitmap Release, thus the source was not evaluated.'
      respond_to do |format|
        format.html { render 'show' }
        format.json { render json: @sequence_source.errors, status: :unprocessable_entity }
      end
    end
  end
end

