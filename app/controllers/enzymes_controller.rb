class EnzymesController < ApplicationController
  load_and_authorize_resource

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
    @hmm_profiles = @enzyme.hmm_profiles.paginate(page: params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enzyme }
    end
  end

  # GET /enzymes/new
  # GET /enzymes/new.json
  def new
    @enzyme = Enzyme.new
    @hmm_profiles = HmmProfile.all
    @parent_candidates = Enzyme.all 
   respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enzyme }
    end
  end

  # GET /enzymes/1/edit
  def edit
    @enzyme = Enzyme.find(params[:id])
    @hmm_profiles = HmmProfile.all
    @parent_candidates = Enzyme.all
  end

  # POST /enzymes
  # POST /enzymes.json
  def create
    @enzyme = Enzyme.new(params[:enzyme])
    @hmm_profiles = HmmProfile.find_all_by_id(params[:hmm_profile_ids])
    @parent_candidates = Enzyme.all

    respond_to do |format|
      if @enzyme.save
        if @hmm_profiles
          @hmm_profiles.each do |profile|
            enzyme_profile = EnzymeProfile.new()
            enzyme_profile.hmm_profile_id = profile.id
            enzyme_profile.enzyme_id = @enzyme.id
            enzyme_profile.save
          end
        end
        format.html { redirect_to @enzyme, notice: 'Enzyme was successfully created.' }
        format.json { render json: @enzyme, status: :created, location: @enzyme }
      else
        @hmm_profiles = HmmProfile.all
        format.html { render action: "new" }
        format.json { render json: @enzyme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /enzymes/1
  # PUT /enzymes/1.json
  def update
    @enzyme = Enzyme.find(params[:id])
    @hmm_profiles = HmmProfile.find_all_by_id(params[:hmm_profile_ids])
    
    @enzyme.hmm_profiles.destroy_all
    respond_to do |format|
      if @enzyme.update_attributes(params[:enzyme])
        if @hmm_profiles
          @hmm_profiles.each do |profile|
            enzyme_profile = EnzymeProfile.new()
            enzyme_profile.hmm_profile_id = profile.id
            enzyme_profile.enzyme_id = @enzyme.id
            enzyme_profile.save
          end
        end

        format.html { redirect_to @enzyme, notice: 'Enzyme was successfully updated.' }
        format.json { head :no_content }
      else
        @hmm_profiles = HmmProfile.all
        @parent_candidates = Enzyme.all
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
