module FileParsers
  def parse_fasta(io)
    updated = 0
    DbSequence.transaction do
      @db_seq_to_update = {}
      DbSequence.includes(:hmm_db_hits).where("sequence IS NULL").each do |dbs|
	dbs.hmm_db_hits.each do |hdb|
	  @db_seq_to_update[hdb.gi] = dbs
	end
      end
      gi = nil
      seq = ''
      File.open(io.path, "r").each do |line|
	line.chomp!
	if line[0..3] == '>gi|'
	  if gi and seq != ''
	    @db_seq_to_update[gi].sequence = seq
	    @db_seq_to_update[gi].save
	    seq = ''
	    updated += 1
	  end
	  gi = line.split('|')[1].to_i
	  gi = nil unless @db_seq_to_update[gi]
	elsif line[0] != '>'
	  seq += line
	end
      end
    end
    updated
  end

  def parse_hmm_tblout(result, io)
    HmmResult.transaction do
      @hmm_result_rows = []
      @db_hits = []	# This will become an array of arrays, with one array per hmm_result_row (i.e. infile row). This is in preparation for a smart way of updating all objects with db_sequence.id...
      @db_hit_cache = {}
      HmmDbHit.all.each do |dbh|
	@db_hit_cache[dbh.gi] = dbh
      end
      File.open("#{io.path}", "r").each_with_index do |line, index|
	line.chomp!
	line.sub!(/^#.*/, '')
	next if line == ''
	fields = line.split(/\s+/)

	individual_db_entries = "#{fields[0]} #{fields[17..-1].join(" ")}".split(/\001/)

	# Try to find an old sequence object that's connected to any gi in this line
	seqgi = individual_db_entries.map { |e| e.split("|")[1].to_i }.detect do |gi| 
	  @db_hit_cache[gi] ? true : false
	end

	present_sequence_id = ( seqgi ? @db_hit_cache[seqgi].db_sequence_id : DbSequence.create.id )	# How does the .db_sequence method call work? Does it do a select always? Can we do that in preparation?
	
	@db_hits << []
	individual_db_entries.each do |entry|
	  entry_fields = entry.split("|")

	  #If any db_hit with the same gi exists, then they share sequence.
	  present_db_hit = @db_hit_cache[entry_fields[1].to_i]
	  
	  unless present_db_hit
	    @db_hits << HmmDbHit.new(
	      :gi => entry_fields[1].to_i,
	      :db => entry_fields[2],
	      :acc => entry_fields[3],
	      :desc => entry_fields[4],
	      :db_sequence_id => present_sequence_id
	    )
	  end
	end
	@hmm_result_rows << add_hmm_result_row(fields,result,present_sequence_id)
        if index % 1000 == 0
          HmmDbHit.import @db_hits.flatten
          HmmResultRow.import @hmm_result_rows
          @db_hits = []
          @hmm_result_rows = []
        end
      end
      HmmDbHit.import @db_hits.flatten
      HmmResultRow.import @hmm_result_rows
    end
  end
  
  def add_hmm_result_row(fields,result, present_sequence_id)
    hmm_result_row = HmmResultRow.new(
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
     :db_sequence_id => present_sequence_id,
     :hmm_result_id => result.id
    )
  end
end
