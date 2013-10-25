class ReleasedDbsController < ApplicationController
  load_and_authorize_resource
  # GET /released_dbs
  # GET /released_dbs.json
  def index
    @released_dbs = ReleasedDb.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @released_dbs }
    end
  end

  # GET /released_dbs/1
  # GET /released_dbs/1.json
  def show
    @released_db = ReleasedDb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @released_db }
    end
  end

  # GET /released_dbs/new
  # GET /released_dbs/new.json
  def new
    @released_db = ReleasedDb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @released_db }
    end
  end

  # GET /released_dbs/1/edit
  def edit
    @released_db = ReleasedDb.find(params[:id])
  end

  # POST /released_dbs
  # POST /released_dbs.json
  def create
    @released_db = ReleasedDb.new(params[:released_db])

    respond_to do |format|
      if @released_db.save
        format.html { redirect_to @released_db, notice: 'Released db was successfully created.' }
        format.json { render json: @released_db, status: :created, location: @released_db }
      else
        format.html { render action: "new" }
        format.json { render json: @released_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /released_dbs/1
  # PUT /released_dbs/1.json
  def update
    @released_db = ReleasedDb.find(params[:id])

    respond_to do |format|
      if @released_db.update_attributes(params[:released_db])
        format.html { redirect_to @released_db, notice: 'Released db was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @released_db.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /released_dbs/1
  # DELETE /released_dbs/1.json
  def destroy
    @released_db = ReleasedDb.find(params[:id])
    @released_db.destroy

    respond_to do |format|
      format.html { redirect_to released_dbs_url }
      format.json { head :no_content }
    end
  end
end
