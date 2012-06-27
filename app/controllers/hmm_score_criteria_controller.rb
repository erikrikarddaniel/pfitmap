class HmmScoreCriteriaController < ApplicationController
  load_and_authorize_resource
  # GET /hmm_score_criteria
  # GET /hmm_score_criteria.json
  def index
    @hmm_score_criteria = HmmScoreCriterion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_score_criteria }
    end
  end

  # GET /hmm_score_criteria/1
  # GET /hmm_score_criteria/1.json
  def show
    @hmm_score_criterion = HmmScoreCriterion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_score_criterion }
    end
  end

  # GET /hmm_score_criteria/new
  # GET /hmm_score_criteria/new.json
  def new
    @hmm_score_criterion = HmmScoreCriterion.new
    @hmm_profiles = HmmProfile.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_score_criterion }
    end
  end

  # GET /hmm_score_criteria/1/edit
  def edit
    @hmm_score_criterion = HmmScoreCriterion.find(params[:id])
    @hmm_profiles = HmmProfile.all
  end

  # POST /hmm_score_criteria
  # POST /hmm_score_criteria.json
  def create
    @hmm_score_criterion = HmmScoreCriterion.new(params[:hmm_score_criterion])

    respond_to do |format|
      if @hmm_score_criterion.save
        format.html { redirect_to @hmm_score_criterion, notice: 'Hmm score criterion was successfully created.' }
        format.json { render json: @hmm_score_criterion, status: :created, location: @hmm_score_criterion }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_score_criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_score_criteria/1
  # PUT /hmm_score_criteria/1.json
  def update
    @hmm_score_criterion = HmmScoreCriterion.find(params[:id])

    respond_to do |format|
      if @hmm_score_criterion.update_attributes(params[:hmm_score_criterion])
        format.html { redirect_to @hmm_score_criterion, notice: 'Hmm score criterion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_score_criterion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_score_criteria/1
  # DELETE /hmm_score_criteria/1.json
  def destroy
    @hmm_score_criterion = HmmScoreCriterion.find(params[:id])
    @hmm_score_criterion.destroy

    respond_to do |format|
      format.html { redirect_to hmm_score_criteria_url }
      format.json { head :no_content }
    end
  end
end
