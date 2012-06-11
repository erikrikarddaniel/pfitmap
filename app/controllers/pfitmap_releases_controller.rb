class PfitmapReleasesController < ApplicationController
  # GET /pfitmap_releases
  # GET /pfitmap_releases.json
  def index
    @pfitmap_releases = PfitmapRelease.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pfitmap_releases }
    end
  end

  # GET /pfitmap_releases/1
  # GET /pfitmap_releases/1.json
  def show
    @pfitmap_release = PfitmapRelease.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pfitmap_release }
    end
  end

  # GET /pfitmap_releases/new
  # GET /pfitmap_releases/new.json
  def new
    @pfitmap_release = PfitmapRelease.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pfitmap_release }
    end
  end

  # GET /pfitmap_releases/1/edit
  def edit
    @pfitmap_release = PfitmapRelease.find(params[:id])
  end

  # POST /pfitmap_releases
  # POST /pfitmap_releases.json
  def create
    @pfitmap_release = PfitmapRelease.new(params[:pfitmap_release])

    respond_to do |format|
      if @pfitmap_release.save
        format.html { redirect_to @pfitmap_release, notice: 'Pfitmap release was successfully created.' }
        format.json { render json: @pfitmap_release, status: :created, location: @pfitmap_release }
      else
        format.html { render action: "new" }
        format.json { render json: @pfitmap_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pfitmap_releases/1
  # PUT /pfitmap_releases/1.json
  def update
    @pfitmap_release = PfitmapRelease.find(params[:id])

    respond_to do |format|
      if @pfitmap_release.update_attributes(params[:pfitmap_release])
        format.html { redirect_to @pfitmap_release, notice: 'Pfitmap release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pfitmap_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pfitmap_releases/1
  # DELETE /pfitmap_releases/1.json
  def destroy
    @pfitmap_release = PfitmapRelease.find(params[:id])
    @pfitmap_release.destroy

    respond_to do |format|
      format.html { redirect_to pfitmap_releases_url }
      format.json { head :no_content }
    end
  end
end
