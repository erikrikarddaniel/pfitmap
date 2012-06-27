class HmmProfilesController < ApplicationController
  load_and_authorize_resource
  helper HmmProfilesHelper

  # GET /hmm_profiles
  # GET /hmm_profiles.json
  def index
    @hmm_profiles = HmmProfile.all
    @hmm_profiles_last_parents = HmmProfile.last_parents.sort_by{|p| p.hierarchy}
    @first_last_parent = @hmm_profiles_last_parents.first
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_profiles }
    end
  end

  # GET /hmm_profiles/1
  # GET /hmm_profiles/1.json
  def show
    @hmm_profile = HmmProfile.find(params[:id])
    @hmm_result = @hmm_profile.hmm_results.build()
    @hmm_results = @hmm_profile.hmm_results.paginate(page: params[:page])
    @sequence_sources = SequenceSource.all
    @hmm_score_criteria = @hmm_profile.hmm_score_criteria
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_profile }
    end
  end

  # GET /hmm_profiles/new
  # GET /hmm_profiles/new.json
  def new
    @parent_candidates = HmmProfile.all
    @hmm_profile = HmmProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_profile }
    end
  end

  # GET /hmm_profiles/1/edit
  def edit
    @parent_candidates = HmmProfile.all
    @hmm_profile = HmmProfile.find(params[:id])
  end

  # POST /hmm_profiles
  # POST /hmm_profiles.json
  def create
    @hmm_profile = HmmProfile.new(params[:hmm_profile])

    respond_to do |format|
      if @hmm_profile.save
        format.html { redirect_to @hmm_profile, notice: 'Hmm profile was successfully created.' }
        format.json { render json: @hmm_profile, status: :created, location: @hmm_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_profiles/1
  # PUT /hmm_profiles/1.json
  def update
    @hmm_profile = HmmProfile.find(params[:id])

    respond_to do |format|
      if @hmm_profile.update_attributes(params[:hmm_profile])
        format.html { redirect_to @hmm_profile, notice: 'Hmm profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_profiles/1
  # DELETE /hmm_profiles/1.json
  def destroy
    @hmm_profile = HmmProfile.find(params[:id])
    @hmm_profile.destroy

    respond_to do |format|
      format.html { redirect_to hmm_profiles_url }
      format.json { head :no_content }
    end
  end
end
