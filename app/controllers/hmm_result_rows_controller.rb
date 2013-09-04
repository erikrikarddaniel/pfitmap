class HmmResultRowsController < ApplicationController
  load_and_authorize_resource
  # GET /hmm_result_rows
  # GET /hmm_result_rows.json
  def index
    @hmm_result_rows = HmmResultRow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_result_rows }
    end
  end

  # GET /hmm_result_rows/1
  # GET /hmm_result_rows/1.json
  def show
    @hmm_result_row = HmmResultRow.find(params[:id])
    @db_entries = @hmm_result_row.db_entries.paginate(page: params[:page])
    @hmm_alignments = @hmm_result_row.hmm_alignments
    @db_sequence = @hmm_result_row.db_sequence

    sequence_source = @hmm_result_row.hmm_result.sequence_source
    @best_hmm_profiles = @db_sequence.best_hmm_profiles_for(sequence_source)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_result_row }
    end
  end

  # GET /hmm_result_rows/new
  # GET /hmm_result_rows/new.json
  def new
    @hmm_result_row = HmmResultRow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hmm_result_row }
    end
  end

  # GET /hmm_result_rows/1/edit
  def edit
    @hmm_result_row = HmmResultRow.find(params[:id])
  end

  # POST /hmm_result_rows
  # POST /hmm_result_rows.json
  def create
    @hmm_result_row = HmmResultRow.new(params[:hmm_result_row])

    respond_to do |format|
      if @hmm_result_row.save
        format.html { redirect_to @hmm_result_row, notice: 'Hmm result row was successfully created.' }
        format.json { render json: @hmm_result_row, status: :created, location: @hmm_result_row }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_result_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hmm_result_rows/1
  # PUT /hmm_result_rows/1.json
  def update
    @hmm_result_row = HmmResultRow.find(params[:id])

    respond_to do |format|
      if @hmm_result_row.update_attributes(params[:hmm_result_row])
        format.html { redirect_to @hmm_result_row, notice: 'Hmm result row was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hmm_result_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hmm_result_rows/1
  # DELETE /hmm_result_rows/1.json
  def destroy
    @hmm_result_row = HmmResultRow.find(params[:id])
    @hmm_result_row.destroy

    respond_to do |format|
      format.html { redirect_to hmm_result_rows_url }
      format.json { head :no_content }
    end
  end
end
