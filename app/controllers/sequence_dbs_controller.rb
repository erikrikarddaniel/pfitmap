class SequenceDbsController < ApplicationController
  # GET /sequence_dbs
  # GET /sequence_dbs.json
  def index
    @sequence_dbs = SequenceDb.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sequence_dbs }
    end
  end

  # GET /sequence_dbs/1
  # GET /sequence_dbs/1.json
  def show
    @sequence_db = SequenceDb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sequence_db }
    end
  end

  # GET /sequence_dbs/new
  # GET /sequence_dbs/new.json
  def new
    @sequence_db = SequenceDb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sequence_db }
    end
  end

  # GET /sequence_dbs/1/edit
  def edit
    @sequence_db = SequenceDb.find(params[:id])
  end

  # POST /sequence_dbs
  # POST /sequence_dbs.json
  def create
    @sequence_db = SequenceDb.new(params[:sequence_db])

    respond_to do |format|
      if @sequence_db.save
        format.html { redirect_to @sequence_db, notice: 'Sequence db was successfully created.' }
        format.json { render json: @sequence_db, status: :created, location: @sequence_db }
      else
        format.html { render action: "new" }
        format.json { render json: @sequence_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sequence_dbs/1
  # PUT /sequence_dbs/1.json
  def update
    @sequence_db = SequenceDb.find(params[:id])

    respond_to do |format|
      if @sequence_db.update_attributes(params[:sequence_db])
        format.html { redirect_to @sequence_db, notice: 'Sequence db was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sequence_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequence_dbs/1
  # DELETE /sequence_dbs/1.json
  def destroy
    @sequence_db = SequenceDb.find(params[:id])
    @sequence_db.destroy

    respond_to do |format|
      format.html { redirect_to sequence_dbs_url }
      format.json { head :no_content }
    end
  end
end
