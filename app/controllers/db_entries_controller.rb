class DbEntriesController < ApplicationController
  load_and_authorize_resource
  # GET /db_entries
  # GET /db_entries.json
  def index
    @db_entries = DbEntry.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @db_entries }
    end
  end

  # GET /db_entries/1
  # GET /db_entries/1.json
  def show
    @db_entry = DbEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @db_entry }
    end
  end

  # GET /db_entries/new
  # GET /db_entries/new.json
  def new
    @db_entry = DbEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @db_entry }
    end
  end

  # GET /db_entries/1/edit
  def edit
    @db_entry = DbEntry.find(params[:id])
  end

  # POST /db_entries
  # POST /db_entries.json
  def create
    @db_entry = DbEntry.new(params[:db_entry])

    respond_to do |format|
      if @db_entry.save
        format.html { redirect_to @db_entry, notice: 'Db entry was successfully created.' }
        format.json { render json: @db_entry, status: :created, location: @db_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @db_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /db_entries/1
  # PUT /db_entries/1.json
  def update
    @db_entry = DbEntry.find(params[:id])

    respond_to do |format|
      if @db_entry.update_attributes(params[:db_entry])
        format.html { redirect_to @db_entry, notice: 'Db entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @db_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /db_entries/1
  # DELETE /db_entries/1.json
  def destroy
    @db_entry = DbEntry.find(params[:id])
    @db_entry.destroy

    respond_to do |format|
      format.html { redirect_to db_entries_url }
      format.json { head :no_content }
    end
  end
end
