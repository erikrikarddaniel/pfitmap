class SequenceDatabasesController < ApplicationController
  # GET /sequence_databases
  # GET /sequence_databases.json
  def index
    @sequence_databases = SequenceDatabase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sequence_databases }
    end
  end

  # GET /sequence_databases/1
  # GET /sequence_databases/1.json
  def show
    @sequence_database = SequenceDatabase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sequence_database }
    end
  end

  # GET /sequence_databases/new
  # GET /sequence_databases/new.json
  def new
    @sequence_database = SequenceDatabase.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sequence_database }
    end
  end

  # GET /sequence_databases/1/edit
  def edit
    @sequence_database = SequenceDatabase.find(params[:id])
  end

  # POST /sequence_databases
  # POST /sequence_databases.json
  def create
    @sequence_database = SequenceDatabase.new(params[:sequence_database])

    respond_to do |format|
      if @sequence_database.save
        format.html { redirect_to @sequence_database, notice: 'Sequence database was successfully created.' }
        format.json { render json: @sequence_database, status: :created, location: @sequence_database }
      else
        format.html { render action: "new" }
        format.json { render json: @sequence_database.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sequence_databases/1
  # PUT /sequence_databases/1.json
  def update
    @sequence_database = SequenceDatabase.find(params[:id])

    respond_to do |format|
      if @sequence_database.update_attributes(params[:sequence_database])
        format.html { redirect_to @sequence_database, notice: 'Sequence database was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sequence_database.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequence_databases/1
  # DELETE /sequence_databases/1.json
  def destroy
    @sequence_database = SequenceDatabase.find(params[:id])
    @sequence_database.destroy

    respond_to do |format|
      format.html { redirect_to sequence_databases_url }
      format.json { head :no_content }
    end
  end
end
