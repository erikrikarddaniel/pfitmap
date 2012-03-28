class HmmResultsController < ApplicationController
  # GET /hmm_results
  # GET /hmm_results.json
  def index
    @hmm_results = HmmResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_results }
    end
  end

  # GET /hmm_results/1
  # GET /hmm_results/1.json
  def show
    @hmm_result = HmmResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_result }
    end
  end

  # GET /hmm_results/new
  # GET /hmm_results/new.json
  def new
    @hmm_result = HmmResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_result }
    end
  end

  # GET /hmm_results/1/edit
  def edit
    @hmm_result = HmmResult.find(params[:id])
  end

  # POST /hmm_results
  # POST /hmm_results.json
  def create
    @hmm_result = HmmResult.new(params[:hmm_result])

    respond_to do |format|
      if @hmm_result.save
        format.html { redirect_to @hmm_result, notice: 'Hmm result was successfully created.' }
        format.json { render json: @hmm_result, status: :created, location: @hmm_result }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_results/1
  # PUT /hmm_results/1.json
  def update
    @hmm_result = HmmResult.find(params[:id])

    respond_to do |format|
      if @hmm_result.update_attributes(params[:hmm_result])
        format.html { redirect_to @hmm_result, notice: 'Hmm result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_results/1
  # DELETE /hmm_results/1.json
  def destroy
    @hmm_result = HmmResult.find(params[:id])
    @hmm_result.destroy

    respond_to do |format|
      format.html { redirect_to hmm_results_url }
      format.json { head :no_content }
    end
  end
end
