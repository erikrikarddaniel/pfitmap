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
            if parse_results(@hmm_result,file)
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
  
  private
  def parse_results(result, io)
    HmmResult.transaction do
      File.open("#{io.path}", "r").each_with_index do |line, index|
        # skip header
        if index > 2
          present_sequence = nil
          line.chomp!
          fields = line.split(/\s+/)
          all_names = "#{fields[0]} #{fields[17..-1].join(" ")}"
          separate_entries_description=all_names.split(/\001/)
          
          separate_entries_description.each do |f|
            entry_fields=f.split("|")
            #If any db_hit with the same gi exists, then they share sequence.
            present_db_hit = HmmDbHit.find_by_gi(entry_fields[1].to_i)
            
            if present_db_hit
              present_sequence = present_db_hit.db_sequence
            end
            
            if not present_sequence
              present_sequence = DbSequence.new()
              present_sequence.save
            end
            
            exact_db_hits = HmmDbHit.where("gi = ? AND db = ? AND acc = ?", entry_fields[1].to_i, entry_fields[2], entry_fields[3])
            if exact_db_hits == []
              exact_db_hit = HmmDbHit.create!(
		:gi => entry_fields[1].to_i,
		:db => entry_fields[2],
		:acc => entry_fields[3],
		:desc => entry_fields[4],
		:db_sequence_id => present_sequence.id
	      )
            end
          end
          hmm_result_row = add_hmm_result_row(fields,result,present_sequence)
        end
      end
    end
  end
  
  def add_hmm_result_row(fields,result, present_sequence)
    hmm_result_row = result.hmm_result_rows.create(
                                                   :target_name => fields[0],
                                                   :target_acc => ( fields[1] == '-' ? fields[0].split('|')[2..3].join(':') : fields[1] ),
                                                   :query_name => fields[2],
                                                   :query_acc => fields[3],
                                                   :fullseq_evalue => fields[4].to_f,
                                                   :fullseq_score => fields[5].to_f,
                                                   :fullseq_bias => fields[6].to_f,
                                                   :bestdom_evalue => fields[7].to_f,
                                                   :bestdom_score => fields[8].to_f,
                                                   :bestdom_bias => fields[9].to_f,
                                                   :domnumest_exp => fields[10].to_f,
                                                   :domnumest_reg => fields[11].to_i,
                                                   :domnumest_clu => fields[12].to_i,
                                                   :domnumest_ov => fields[13].to_i,
                                                   :domnumest_env => fields[14].to_i,
                                                   :domnumest_dom => fields[15].to_i,
                                                   :domnumest_rep => fields[16].to_i,
                                                   :domnumest_inc => fields[17].to_i,
                                                   :db_sequence_id => present_sequence.id
                                                   )
  end

  def hmm_result_params
    params[:hmm_result].slice(:executed)
  end
end
