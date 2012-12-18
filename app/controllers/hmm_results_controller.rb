require 'file_parsers'
include FileParsers

class HmmResultsController < ApplicationController
  load_and_authorize_resource :hmm_result, :except => :create
  skip_authorization_check :only => :create

  # GET /hmm_results
  # GET /hmm_results.json
  def index
    @hmm_results = HmmResult.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hmm_results }
    end
  end

  # GET /hmm_results/1
  # GET /hmm_results/1.json
  def show
    @hmm_result = HmmResult.find(params[:id])
    @hmm_result_rows = @hmm_result.hmm_result_rows.paginate(page: params[:page], order: "fullseq_score DESC")
    # Generate histogram
    @chart, @chart2 = @hmm_result.create_histogram
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_result }
    end
  end

  # GET /hmm_results/1/edit
  def edit
    @hmm_result = HmmResult.find(params[:id])
  end

  # POST /hmm_results
  # POST /hmm_results.json
  def create
    if current_user.nil? || current_user.role != "admin"
      flash[:error] = "Please sign in to register result"
      redirect_to root_path
    else
      @hmm_profile = HmmProfile.find(params[:hmm_profile_id])
      # Squirrel away the file parameter to avoid problems when creating the result object
      file = params[:hmm_result].delete(:file)
      if file
        @hmm_result = @hmm_profile.hmm_results.new(params[:hmm_result].merge(:executed => File.mtime(file.path)))
      else
        @hmm_result = @hmm_profile.hmm_results.new(params[:hmm_result].merge(:executed => 101.years.ago))
      end
      respond_to do |format|
        if file
          if @hmm_result.save
            if parse_hmm_tblout(@hmm_result,file)
              format.html { redirect_to hmm_result_path(@hmm_result), notice: 'Hmm result was successfully created.' }
              format.json { render json: hmm_result_path(@hmm_result), status: :created, location: @hmm_result }
            else
              ActiveRecord.delete(@hmm_result.id)
              format.html { redirect_to @hmm_profile, notice: 'Error while parsing the given file' }
              format.json { render json: @hmm_result, status: :unprocessable_entity }
            end
          else
            flash[:error] = @hmm_result.errors.full_messages.inspect
            format.html { redirect_to hmm_profile_path(@hmm_profile)}
            format.json { render json: @hmm_result.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to hmm_profile_path(@hmm_profile), notice: 'No file given' }
          format.json { render json: @hmm_result.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # DELETE /hmm_results/1
  # DELETE /hmm_results/1.json
  def destroy
    @hmm_result = HmmResult.find(params[:id])
    @hmm_result.destroy
    
    respond_to do |format|
      format.html { redirect_to hmm_results_url }
      format.json { head :no_content }
    end
  end

  def hmm_result_params
    params[:hmm_result].slice(:executed)
  end
end
