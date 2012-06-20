class DbSequencesController < ApplicationController
  load_and_authorize_resource
  # GET /db_sequences
  # GET /db_sequences.json
  def index
    @db_sequences = DbSequence.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @db_sequences }
    end
  end

  # GET /db_sequences/1
  # GET /db_sequences/1.json
  def show
    @db_sequence = DbSequence.find(params[:id])
    @best_profile = HmmProfile.find(@db_sequence.best_hmm_profile)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @db_sequence }
    end
  end

  # GET /db_sequences/new
  # GET /db_sequences/new.json
  def new
    @db_sequence = DbSequence.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @db_sequence }
    end
  end

  # GET /db_sequences/1/edit
  def edit
    @db_sequence = DbSequence.find(params[:id])
  end

  # POST /db_sequences
  # POST /db_sequences.json
  def create
    @db_sequence = DbSequence.new(params[:db_sequence])

    respond_to do |format|
      if @db_sequence.save
        format.html { redirect_to @db_sequence, notice: 'Db sequence was successfully created.' }
        format.json { render json: @db_sequence, status: :created, location: @db_sequence }
      else
        format.html { render action: "new" }
        format.json { render json: @db_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /db_sequences/1
  # PUT /db_sequences/1.json
  def update
    @db_sequence = DbSequence.find(params[:id])

    respond_to do |format|
      if @db_sequence.update_attributes(params[:db_sequence])
        format.html { redirect_to @db_sequence, notice: 'Db sequence was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @db_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /db_sequences/1
  # DELETE /db_sequences/1.json
  def destroy
    @db_sequence = DbSequence.find(params[:id])
    @db_sequence.destroy

    respond_to do |format|
      format.html { redirect_to db_sequences_url }
      format.json { head :no_content }
    end
  end
end
