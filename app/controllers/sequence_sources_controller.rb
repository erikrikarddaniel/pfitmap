class SequenceSourcesController < ApplicationController
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
    @hmm_results = @sequence_source.hmm_results.paginate(page: params[:page])
    @hmm_profiles_last_parents = HmmProfile.last_parents.sort_by{|p| p.hierarchy }
    @hmm_profiles = @sequence_source.hmm_profiles

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
    @sequence_source = SequenceSource.find(params[:sequence_source_id])
    @head_release = PfitmapRelease.find_head_release

    if not @head_release
      @hmm_results = @sequence_source.hmm_results.paginate(page: params[:page])
      @hmm_profiles_last_parents = HmmProfile.last_parents.sort_by{|p| p.hierarchy }
      @hmm_profiles = @sequence_source.hmm_profiles
      flash[:error] = 'There is no current Pfitmap Release, thus the source was not evaluated.'
      respond_to do |format|
        format.html { render 'show' }
        format.json { render json: @sequence_source.errors, status: :unprocessable_entity }
      end
    else
      @sequence_source.evaluate
       flash[:success] = 'Sequence source was successfully evaluated.'
      respond_to do |format|
        format.html { redirect_to @head_release }
        format.json { head :no_content }
      end
    end
  end
end

