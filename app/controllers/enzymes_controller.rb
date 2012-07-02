class EnzymesController < ApplicationController
  # GET /enzymes
  # GET /enzymes.json
  def index
    @enzymes = Enzyme.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @enzymes }
    end
  end

  # GET /enzymes/1
  # GET /enzymes/1.json
  def show
    @enzyme = Enzyme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enzyme }
    end
  end

  # GET /enzymes/new
  # GET /enzymes/new.json
  def new
    @enzyme = Enzyme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enzyme }
    end
  end

  # GET /enzymes/1/edit
  def edit
    @enzyme = Enzyme.find(params[:id])
  end

  # POST /enzymes
  # POST /enzymes.json
  def create
    @enzyme = Enzyme.new(params[:enzyme])

    respond_to do |format|
      if @enzyme.save
        format.html { redirect_to @enzyme, notice: 'Enzyme was successfully created.' }
        format.json { render json: @enzyme, status: :created, location: @enzyme }
      else
        format.html { render action: "new" }
        format.json { render json: @enzyme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /enzymes/1
  # PUT /enzymes/1.json
  def update
    @enzyme = Enzyme.find(params[:id])

    respond_to do |format|
      if @enzyme.update_attributes(params[:enzyme])
        format.html { redirect_to @enzyme, notice: 'Enzyme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @enzyme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enzymes/1
  # DELETE /enzymes/1.json
  def destroy
    @enzyme = Enzyme.find(params[:id])
    @enzyme.destroy

    respond_to do |format|
      format.html { redirect_to enzymes_url }
      format.json { head :no_content }
    end
  end
end
