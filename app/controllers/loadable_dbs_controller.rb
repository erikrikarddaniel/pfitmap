class LoadableDbsController < ApplicationController
  load_and_authorize_resource

  # GET /loadable_dbs
  # GET /loadable_dbs.json
  def index
    @loadable_dbs = LoadableDb.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @loadable_dbs }
    end
  end

  # GET /loadable_dbs/1
  # GET /loadable_dbs/1.json
  def show
    @loadable_db = LoadableDb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @loadable_db }
    end
  end

  # GET /loadable_dbs/new
  # GET /loadable_dbs/new.json
  def new
    @loadable_db = LoadableDb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @loadable_db }
    end
  end

  # GET /loadable_dbs/1/edit
  def edit
    @loadable_db = LoadableDb.find(params[:id])
  end

  # POST /loadable_dbs
  # POST /loadable_dbs.json
  def create
    @loadable_db = LoadableDb.new(params[:loadable_db])

    respond_to do |format|
      if @loadable_db.save
        format.html { redirect_to @loadable_db, notice: 'Loadable db was successfully created.' }
        format.json { render json: @loadable_db, status: :created, location: @loadable_db }
      else
        format.html { render action: "new" }
        format.json { render json: @loadable_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /loadable_dbs/1
  # PUT /loadable_dbs/1.json
  def update
    @loadable_db = LoadableDb.find(params[:id])

    respond_to do |format|
      if @loadable_db.update_attributes(params[:loadable_db])
        format.html { redirect_to @loadable_db, notice: 'Loadable db was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @loadable_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loadable_dbs/1
  # DELETE /loadable_dbs/1.json
  def destroy
    @loadable_db = LoadableDb.find(params[:id])
    @loadable_db.destroy

    respond_to do |format|
      format.html { redirect_to loadable_dbs_url }
      format.json { head :no_content }
    end
  end
end
