class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @profile = Profile.find(@result.profile_id)
    @result_rows = @result.result_rows.paginate(page: params[:page])
  end
  
  def new
    @result= Result.new
    @profiles = Profile.all
  end

  def create
    # Squirrel away the file parameter to avoid problems when creating the result object
    file = params[:result].delete(:file)
    
    @result = Result.new(params[:result], :executed => File.mtime(file.path))

    if @result.save
      parse_results(@result,file) if file
      flash[:success] = "The new result was successfully saved!"
      redirect_to @result
    else
      render 'new'
    end
  end
  
  def parse_results(result, io)
    Result.transaction do
      io.read.each do |line|
        line.chomp!
        fields = line.split(/\s+/)
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
                                                       :domnumest_inc => fields[17].to_i
                                                       )
        all_names = "#{fields[0]} #{fields[17..-1].join(" ")}"
        separate_entries=all_names.split(/\001/)
        separate_entries.each do |f|
          entry_fields=f.split("|")
          if present_db_hit = HmmDbHit.find(:gi => entry_fields[1].to_i)
            HmmDbHitsHmmResult.create(:db_hit_id => present_db_hit.id, :result_row_id => hmm_result_row.id )
          else            
            hmmdbhit = HMMDBHit.create!(
                                     :gi => entry_fields[1].to_i,
                                     :db => entry_fields[2],
                                     :acc => entry_fields[3],
                                     :desc => entry_fields[4]
                                     )
            HMMDBHitsHMMResult.create!(:db_hit_id => hmmdbhit.id, :result_row_id => hmm_result_row.id )
          end
        end
      end
    end
  end
end
