class ProteinCountsController < ApplicationController
  # GET /protein_counts
  # GET /protein_counts.json
  def index
    @protein_counts = ProteinCount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protein_counts }
    end
  end

  # GET /protein_counts/1
  # GET /protein_counts/1.json
  def show
    @protein_count = ProteinCount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @protein_count }
    end
  end

  # GET /protein_counts/new
  # GET /protein_counts/new.json
  def new
    @protein_count = ProteinCount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @protein_count }
    end
  end

  # GET /protein_counts/1/edit
  def edit
    @protein_count = ProteinCount.find(params[:id])
  end

  # POST /protein_counts
  # POST /protein_counts.json
  def create
    @protein_count = ProteinCount.new(params[:protein_count])

    respond_to do |format|
      if @protein_count.save
        format.html { redirect_to @protein_count, notice: 'Protein count was successfully created.' }
        format.json { render json: @protein_count, status: :created, location: @protein_count }
      else
        format.html { render action: "new" }
        format.json { render json: @protein_count.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /protein_counts/1
  # PUT /protein_counts/1.json
  def update
    @protein_count = ProteinCount.find(params[:id])

    respond_to do |format|
      if @protein_count.update_attributes(params[:protein_count])
        format.html { redirect_to @protein_count, notice: 'Protein count was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @protein_count.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /protein_counts/1
  # DELETE /protein_counts/1.json
  def destroy
    @protein_count = ProteinCount.find(params[:id])
    @protein_count.destroy

    respond_to do |format|
      format.html { redirect_to protein_counts_url }
      format.json { head :no_content }
    end
  end
end
