class HmmDbHitsController < ApplicationController
  # GET /hmm_db_hits
  # GET /hmm_db_hits.json
  def index
    @hmm_db_hits = HmmDbHit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_db_hits }
    end
  end

  # GET /hmm_db_hits/1
  # GET /hmm_db_hits/1.json
  def show
    @hmm_db_hit = HmmDbHit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_db_hit }
    end
  end

  # GET /hmm_db_hits/new
  # GET /hmm_db_hits/new.json
  def new
    @hmm_db_hit = HmmDbHit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_db_hit }
    end
  end

  # GET /hmm_db_hits/1/edit
  def edit
    @hmm_db_hit = HmmDbHit.find(params[:id])
  end

  # POST /hmm_db_hits
  # POST /hmm_db_hits.json
  def create
    @hmm_db_hit = HmmDbHit.new(params[:hmm_db_hit])

    respond_to do |format|
      if @hmm_db_hit.save
        format.html { redirect_to @hmm_db_hit, notice: 'Hmm db hit was successfully created.' }
        format.json { render json: @hmm_db_hit, status: :created, location: @hmm_db_hit }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_db_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_db_hits/1
  # PUT /hmm_db_hits/1.json
  def update
    @hmm_db_hit = HmmDbHit.find(params[:id])

    respond_to do |format|
      if @hmm_db_hit.update_attributes(params[:hmm_db_hit])
        format.html { redirect_to @hmm_db_hit, notice: 'Hmm db hit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_db_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_db_hits/1
  # DELETE /hmm_db_hits/1.json
  def destroy
    @hmm_db_hit = HmmDbHit.find(params[:id])
    @hmm_db_hit.destroy

    respond_to do |format|
      format.html { redirect_to hmm_db_hits_url }
      format.json { head :no_content }
    end
  end
end
