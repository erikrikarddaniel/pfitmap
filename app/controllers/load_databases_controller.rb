class LoadDatabasesController < ApplicationController
  load_and_authorize_resource
  before_filter :get_sequence_database
  # GET /load_databases
  # GET /load_databases.json
  def index
    @load_databases = LoadDatabase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @load_databases }
    end
  end

  # GET /load_databases/1
  # GET /load_databases/1.json
  def show
    @load_database = LoadDatabase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @load_database }
    end
  end

  # GET /load_databases/new
  # GET /load_databases/new.json
  def new
    @load_database = LoadDatabase.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @load_database }
    end
  end

  # GET /load_databases/1/edit
  def edit
    @load_database = LoadDatabase.find(params[:id])
  end

  # POST /load_databases
  # POST /load_databases.json
  def create
    @load_database = @sequence_database.load_databases.new(params[:load_database])

    respond_to do |format|
      if @load_database.save
        format.html { redirect_to @sequence_database, notice: 'Load database was successfully created.' }
        format.json { render json: @load_database, status: :created, location: @load_database }
      else
        format.html { render action: "new" }
        format.json { render json: @load_database.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /load_databases/1
  # PUT /load_databases/1.json
  def update
    @load_database = LoadDatabase.find(params[:id])
    ld = params[:load_database]
    @load_database.taxonset = ld[:taxonset]
    @load_database.name = ld[:name]
    @load_database.description = ld[:description]
    @load_database.active =ld[:active]
    respond_to do |format|
      
      if @load_database.save
        format.html { redirect_to @sequence_database, notice: 'Load database was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @load_database.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /load_databases/1
  # DELETE /load_databases/1.json
  def destroy
    @load_database = LoadDatabase.find(params[:id])
    @load_database.destroy

    respond_to do |format|
      format.html { redirect_to @sequence_database }
      format.json { head :no_content }
    end
  end

  private
  
  def get_sequence_database
    @sequence_database = SequenceDatabase.find(params[:sequence_database_id])
  end
end
