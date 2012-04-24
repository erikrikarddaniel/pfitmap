class HmmResultsController < ApplicationController
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
    @hmm_result_rows = @hmm_result.hmm_result_rows.paginate(page: params[:page])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hmm_result }
    end
  end

  # GET /hmm_results/new
  # GET /hmm_results/new.json
  def new
    @hmm_result = HmmResult.new
    warn "#{__FILE__}#{__LINE__} params: #{params.inspect}"
    @profile = HmmProfile.find(params[:hmm_profile_id])
    @sequence_dbs = SequenceDb.all
    
    respond_to do |format|
      format.html # new.html.erb
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
    warn "******************************************************************"
    warn "#{__FILE__}:#{__LINE__}: params: #{params.inspect}"
    # Squirrel away the file parameter to avoid problems when creating the result object
    file = params[:hmm_result].delete(:file)
    hmm_profile = HmmProfile.find(params[:hmm_result].delete(:hmm_profile_id))
    if file
      @hmm_result = hmm_profile.hmm_results.new(params[:hmm_result].merge(:executed => File.mtime(file.path)))
      logger.debug "Logging hmm_results attributes #{@hmm_result.attributes.inspect}"
      logger.debug "Logging hmm_results params #{params[:hmm_result]}"
      logger.debug "Logging File mtime  #{File.mtime(file.path)}"
    else
      @hmm_result = hmm_profile.hmm_results.new(params[:hmm_result].merge(:executed => 101.years.ago))
    end
    respond_to do |format|
      if @hmm_result.save
        parse_results(@hmm_result,file) if file
        format.html { redirect_to @hmm_result, notice: 'Hmm result was successfully created.' }
        format.json { render json: @hmm_result, status: :created, location: @hmm_result }
      else
        format.html { render action: "new" }
        format.json { render json: @hmm_result.errors, status: :unprocessable_entity }
      end
    end
  end

  def parse_results(result, io)
    logger.debug "Logging Entering parsing"
    HmmResult.transaction do
      logger.debug "Logging Inside transaction"
      logger.debug "Logging length of io.read #{io.read.length}"
      logger.debug "Logging number of newlines #{io.read.count("\n")}"
      logger.debug "Logging class of io.read.each_line #{io.read.each_line.class}"
      logger.debug "Logging first 100 chars: pending}"
      File.open("#{io.path}", "r").each_with_index do |line, index|
        # skip header
        if index > 2
          logger.debug "Logging one line before chomp"
          line.chomp!
          logger.debug "Logging one line before fields"
          fields = line.split(/\s+/)
          logger.debug "Logging the fields #{fields}"
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
                                                         #:domnumest_env => fields[15].to_i,
                                                         :domnumest_rep => fields[16].to_i,
                                                         :domnumest_inc => fields[17].to_i
                                                         )
          all_names = "#{fields[0]} #{fields[17..-1].join(" ")}"
          separate_entries=all_names.split(/\001/)
          separate_entries.each do |f|
            entry_fields=f.split("|")
            present_db_hit = HmmDbHit.find_by_gi(entry_fields[1].to_i)
            if present_db_hit
              DbSequence.create(:hmm_db_hit_id => present_db_hit.id, :hmm_result_row_id => hmm_result_row.id )
            else            
              hmmdbhit = HmmDbHit.create!(
                                          :gi => entry_fields[1].to_i,
                                          :db => entry_fields[2],
                                          :acc => entry_fields[3],
                                          :desc => entry_fields[4]
                                          )
              DbSequence.create!(:hmm_db_hit_id => hmmdbhit.id, :hmm_result_row_id => hmm_result_row.id )
            end
          end
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
end
