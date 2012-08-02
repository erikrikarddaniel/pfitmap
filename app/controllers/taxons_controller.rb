class TaxonsController < ApplicationController
  load_and_authorize_resource :except => :ajax_list
  skip_authorization_check :only => :ajax_list

  # GET /taxons
  # GET /taxons.json
  def index
    @taxons = Taxon.all
    @taxon_roots = Taxon.roots
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxons }
    end
  end

  # GET /taxons/1
  # GET /taxons/1.json
  def show
    @taxon = Taxon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxon }
    end
  end

  # GET /taxons/new
  # GET /taxons/new.json
  def new
    @taxon = Taxon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxon }
    end
  end

  # GET /taxons/1/edit
  def edit
    @taxon = Taxon.find(params[:id])
  end

  # POST /taxons
  # POST /taxons.json
  def create
    @taxon = Taxon.new(params[:taxon])

    respond_to do |format|
      if @taxon.save
        format.html { redirect_to @taxon, notice: 'Taxon was successfully created.' }
        format.json { render json: @taxon, status: :created, location: @taxon }
      else
        format.html { render action: "new" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxons/1
  # PUT /taxons/1.json
  def update
    @taxon = Taxon.find(params[:id])

    respond_to do |format|
      if @taxon.update_attributes(params[:taxon])
        format.html { redirect_to @taxon, notice: 'Taxon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxons/1
  # DELETE /taxons/1.json
  def destroy
    @taxon = Taxon.find(params[:id])
    @taxon.destroy

    respond_to do |format|
      format.html { redirect_to taxons_url }
      format.json { head :no_content }
    end
  end
  # GET /taxons/1
  # GET /taxons/1.json
  def ajax_list
    @taxon = Taxon.find(params[:taxon_id])
    @taxons = @taxon.children
    respond_to do |format|
      format.html # show.html.erb
      format.js { render :partial => 'taxons/ajax_list', :locals => {:taxons => @taxons}, :content_type => 'text/html' }
      format.json { render json: @taxon }
    end
  end

  def ajax_list_protein_counts
    @taxon = Taxon.find(params[:taxon_id])
    @taxons = @taxon.children
    respond_to do |format|
      format.html # show.html.erb
      format.js { render :partial => 'taxons/ajax_list_protein_counts', :locals => {:taxons => @taxons}, :content_type => 'text/html' }
      format.json { render json: @taxon }
    end
  end

end
