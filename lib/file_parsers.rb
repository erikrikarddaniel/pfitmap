module FileParsers
  def self.import_external_db_fasta(io)
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
  
  def parse_hmmout(result, io)
    domain_ack = []
    HmmResult.transaction do
      @hmm_alignments = []
      gi_row_hash = gi_to_result_row_hash(result)
      first_domain_found = nil
      end_of_file = nil
      File.open("#{io.path}", "r").each_with_index do |line, index|
        line.chomp!
	line.sub!(/^#.*/, '')
        if first_domain_found
          if ( line =~ />>(.*)/)
            if domain_ack != []
              @hmm_alignments += parse_single_protein(domain_ack, gi_row_hash)
            end
            domain_ack = [line]
          elsif line =~  /^Internal pipeline statistics/
            break
          else
            domain_ack << line
          end
        else
          first_domain_found = (line[0..16] == "Domain annotation")
        end
	next if line == '' or (not first_domain_found)
      end
      # Last domain in file
      @hmm_alignments += parse_single_protein(domain_ack, gi_row_hash)
      HmmAlignment.import @hmm_alignments
    end
  end

  def gi_to_result_row_hash(result)
    h = {}
    result.hmm_result_rows.all(:include => :hmm_db_hits).each do |rr|
      rr.hmm_db_hits.each do |db_hit|
        h[db_hit.gi] = rr.id
      end
    end
    return h
  end
  
  def parse_single_protein(lines, gi_to_row_id)
    domsummary = false
    domainlines = nil
    row_id = get_rowid_from_line(lines[0], gi_to_row_id)
    alignments = []
    lines.each_with_index do |line, index|
      if line[0..3] == ' ---' and not domsummary and not domainlines
        domsummary = true
      elsif domsummary and line != ''
        a = HmmAlignment.new(hmm_result_row_id: row_id)
        fields = line.split("\s")
        a.domain_num = fields[0].to_i
        a.score = fields[2].to_f
        a.bias = fields[3].to_f
        a.cevalue = fields[4].to_f
        a.ievalue = fields[5].to_f
        a.hmmfrom = fields[6].to_i
        a.hmmto = fields[7].to_i
        a.alifrom = fields[9].to_i
        a.alito = fields[10].to_i
        a.envfrom = fields[12].to_i
        a.envto = fields[13].to_i
        a.acc = fields[15].to_f
        alignments << a
      elsif domsummary and line =~ /^\s*$/
        domsummary = false
        domainlines = []
      elsif domainlines and line =~ /== domain (\d+)/
        n = $1.to_i
        parse_domain_lines(domainlines, alignments[n - 2]) if n > 1
        domainlines = []
      elsif domainlines
        domainlines << line
      end
    end
    parse_domain_lines(domainlines, alignments[-1])
    return alignments
  end

  def get_rowid_from_line(line, gi_to_row_id)
    gi = line.split("|")[1].to_i
    raise "Didn't find HmmResultRow corresponding to '#{line}'" unless gi_to_row_id[gi]
    return gi_to_row_id[gi]
  end

  def parse_domain_lines(lines, aln)
    aln.hmm_line = ''
    aln.match_line = ''
    aln.target_line = ''
    aln.pp_line = ''
    startpos = nil
    len = nil
    lines.each_with_index do |line, i|
      next if line =~ /^\s*$/
      if i % 5 == 0
        a = line.split(/\s+/)[-2]
        startpos = line.index(a)
        len = a.length
      end
      a = line[startpos, len]
      case i % 5
      when 0
        aln.hmm_line += a
      when 1
        aln.match_line += a
      when 2
        aln.target_line += a
      when 3
        aln.pp_line += a
      end
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
