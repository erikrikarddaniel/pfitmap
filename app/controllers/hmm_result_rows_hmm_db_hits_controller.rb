class HmmResultRowsHmmDbHitsController < ApplicationController
  # GET /hmm_result_rows_hmm_db_hits
  # GET /hmm_result_rows_hmm_db_hits.json
  def index
    @hmm_result_rows_hmm_db_hits = HmmResultRowsHmmDbHit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_result_rows_hmm_db_hits }
    end
  end

  # GET /hmm_result_rows_hmm_db_hits/1
  # GET /hmm_result_rows_hmm_db_hits/1.json
  def show
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_result_rows_hmm_db_hit }
    end
  end

  # GET /hmm_result_rows_hmm_db_hits/new
  # GET /hmm_result_rows_hmm_db_hits/new.json
  def new
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_result_rows_hmm_db_hit }
    end
  end

  # GET /hmm_result_rows_hmm_db_hits/1/edit
  def edit
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.find(params[:id])
  end

  # POST /hmm_result_rows_hmm_db_hits
  # POST /hmm_result_rows_hmm_db_hits.json
  def create
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.new(params[:hmm_result_rows_hmm_db_hit])

    respond_to do |format|
      if @hmm_result_rows_hmm_db_hit.save
        format.html { redirect_to @hmm_result_rows_hmm_db_hit, notice: 'Hmm result rows hmm db hit was successfully created.' }
        format.json { render json: @hmm_result_rows_hmm_db_hit, status: :created, location: @hmm_result_rows_hmm_db_hit }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_result_rows_hmm_db_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_result_rows_hmm_db_hits/1
  # PUT /hmm_result_rows_hmm_db_hits/1.json
  def update
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.find(params[:id])

    respond_to do |format|
      if @hmm_result_rows_hmm_db_hit.update_attributes(params[:hmm_result_rows_hmm_db_hit])
        format.html { redirect_to @hmm_result_rows_hmm_db_hit, notice: 'Hmm result rows hmm db hit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_result_rows_hmm_db_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_result_rows_hmm_db_hits/1
  # DELETE /hmm_result_rows_hmm_db_hits/1.json
  def destroy
    @hmm_result_rows_hmm_db_hit = HmmResultRowsHmmDbHit.find(params[:id])
    @hmm_result_rows_hmm_db_hit.destroy

    respond_to do |format|
      format.html { redirect_to hmm_result_rows_hmm_db_hits_url }
      format.json { head :no_content }
    end
  end
end
