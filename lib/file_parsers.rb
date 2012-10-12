module FileParsers
  def parse_hmm_tblout(result, io)
    HmmResult.transaction do
      File.open("#{io.path}", "r").each_with_index do |line, index|
	line.chomp!
	line.sub!(/^#.*/, '')
	next if line == ''
	fields = line.split(/\s+/)

	individual_db_entries = "#{fields[0]} #{fields[17..-1].join(" ")}".split(/\001/)

	# Try to find an old sequence object that's connected to any gi in this line
	seqgi = individual_db_entries.map { |e| e.split("|")[1].to_i }.detect do |gi| 
	  HmmDbHit.find_by_gi(gi) ? true : false
	end

	present_sequence = ( seqgi ? HmmDbHit.find_by_gi(seqgi).db_sequence : DbSequence.create )
	
	individual_db_entries.each do |entry|
	  entry_fields = entry.split("|")
	  #If any db_hit with the same gi exists, then they share sequence.
	  present_db_hit = HmmDbHit.find_by_gi(entry_fields[1].to_i)
	  
	  # I think this incorrect as it may find a DbSequence object later in the line.
	  # Moving that logic to before this loop, but letting the code stay until I have
	  # a test case.
#	  if present_db_hit
#	    present_sequence = present_db_hit.db_sequence
#	  end
#	  
#	  if not present_sequence
#	    present_sequence = DbSequence.new()
#	    present_sequence.save
#	  end
	  
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
end
