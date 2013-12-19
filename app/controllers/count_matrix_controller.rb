class CountMatrixController < ApplicationController
  load_and_authorize_resource

  def get_counts
    # Initialize constants
    @tl = Taxon::TAXA		# Taxa column names
    @pl = Protein::PROT_LEVELS	# Protein column names
    @column_names = Taxon::TAXA_PROPER_NAMES.merge({"no_genomes"=>"Nr Genomes"}).merge(Protein::PROT_PROPER_NAMES) # Proper naming of columns
    # Unescape all parameter strings
    params.each do |k,v|
      params[k] = URI.unescape(v)
    end

    # Initialize new CountMatrix object
    @cm = CountMatrix.new
    if params[:release]
      @pfr = PfitmapRelease.find(:first, conditions: {release: params[:release]})
    elsif session[:release_id]
      @pfr = PfitmapRelease.find(session[:release_id])
      params[:release] = @pfr.release
    else
      @pfr = PfitmapRelease.find_current_release
      params[:release] = @pfr.release
    end

    # Get all released dbs for the current pfitmap release
    @released_dbs = ReleasedDb.where(pfitmap_release_id: @pfr.id)
    # Get all load databases for the relesed dbs
    @load_dbs = LoadDatabase.where(id: @released_dbs.map {|rd| rd.load_database_id})
    # Filter on specific db
    unless params[:db]
      params[:db] = @load_dbs.last.name
    end
    @load_db = LoadDatabase.find(:first, conditions: {name: params[:db]})
    # Get the specific released db for the pfitmap release and the database
    @rd = ReleasedDb.find(:first, conditions: {pfitmap_release_id: @pfr.id, load_database_id: @load_db})


    #Selecting which taxon ranks to include in the query
    @tax_levels = params[:taxon_level].in?(@tl) ? @tl.slice(0..@tl.index(params[:taxon_level])) : [@tl[0]]

    #Selecting which protein ranks to inlcude in the query
    @prot_levels = params[:protein_level].in?(@pl) ? @pl.slice(0..@pl.index(params[:protein_level])) : [@pl[0]]

    @cm.release = @pfr.release
    @cm.taxon_level = @tax_levels[-1]
    @cm.protein_level = @prot_levels[-1]
    @cm.db = @load_db.name

    if @cm.valid?

      filter_params = {released_db_id: @rd.id}
      taxon_filter = ["released_db_id = :released_db_id"]
      protein_filter = ["released_db_id = :released_db_id"]
      @tax_levels.each do |t|
        if t.in?(params)
          filter_params[t.to_sym] = params[t].split("(,)")
          taxon_filter.append("#{t} IN (:#{t.to_sym})")
        end
      end
      taxon_filter_string = taxon_filter.join(" AND ")

      @prot_levels.each do |p|
        if p.in?(params)
          filter_params[p.to_sym] = params[p].split("(,)")
          protein_filter.append("#{p} IN (:#{p.to_sym})")
        end
      end
      protein_filter_string = protein_filter.join(" AND ")

      tax_levels_string = "#{@tax_levels.map{|t| "#{t}"}.join(",")}"
      prot_levels_string = "#{@prot_levels.map{|p| "#{p}"}.join(",")}"

      tax_genomes_counts = 
        Taxon.select(tax_levels_string + ", count(*) AS no_genomes")
	     .where(taxon_filter_string,filter_params)
	     .group(tax_levels_string)
	     .order(tax_levels_string)

      @countmt = {}
      tax_genomes_counts.each do |tgc|
        cmt = CountMatrixTaxon.new
        @tax_levels.map{|t| cmt[t] = tgc[t]}
        cmt.no_genomes = tgc.no_genomes
        @countmt[cmt.hierarchy] = cmt
      end
      prot_count = 
	{ protfamily: ProteinFamilyCount, 
	  protclass: ProteinClassCount, 
	  subclass: ProteinSubClassCount, 
	  protgroup: ProteinGroupCount, 
	  subgroup: ProteinSubGroupCount, 
	  subsubgroup: ProteinSubSubGroupCount
	}[@cm.protein_level.to_sym]

      tax_protein_counts = 
        prot_count.select(
	  "SUM(n_proteins) AS no_proteins, COUNT(n_genomes_w_protein) AS no_genomes_with_proteins, STRING_AGG(counted_accessions, ',') AS counted_accessions, STRING_AGG(all_accessions,',') AS all_accessions, #{tax_levels_string},#{prot_levels_string}"
	).where((taxon_filter + protein_filter + [ "#{@cm.protein_level} IS NOT NULL" ]).join(" AND "),filter_params)
		  .group("#{tax_levels_string}, #{prot_levels_string}")
		  .order("#{tax_levels_string}, #{prot_levels_string}")

      tax_protein_counts.each do |tpc| 
        cmtp = CountMatrixTaxonProtein.new
        taxon = @tl.map{|t| tpc[t] }.join(":")
        @prot_levels.map{|p| cmtp[p] = tpc[p]}
        cmtp.no_proteins = tpc.no_proteins
        cmtp.no_genomes_with_proteins = tpc.no_genomes_with_proteins
	cmtp.counted_accessions = tpc.counted_accessions
	cmtp.all_accessions = tpc.all_accessions
        @countmt[taxon].proteins.append(cmtp.attributes)
      end
      @cm.taxons = @countmt.values.map{|c| c.attributes}

      # Set DOM variables to use in D3 Javascript
      # ('gon' is client accessible)
      gon.tax_columns = [@cm.taxon_level, "no_genomes"]
      gon.prot_columns = [
	filter_params[@cm.protein_level.to_sym], 
	tax_protein_counts.map { |t| t[@cm.protein_level] }
      ].compact.reduce([],:|)
      gon.columns = gon.tax_columns + gon.prot_columns
      gon.column_names = @column_names
      gon.taxon_levels = @tax_levels
      gon.protein_levels = @prot_levels
      gon.cm = @cm.attributes.to_json
      gon.tl = @tl
      gon.pl = @pl
    end

    if @cm.valid?
      respond_to do |format|
        format.html { render 'count_matrix' }
        format.json{ render json: @cm.attributes }
      end
    else
      respond_to do |format|
        format.html { render 'count_matrix' }
      end
    end
  end


  def fetch_sequences
    accessions = params[:accessions]
    type = params[:accessions_type]
    sequences = BiosqlWeb.get_sequences_by_accessions(accessions,type)
    respond_to do |format|
#      format.html { send_data(sequences, filename: "pfitmap.fasta") }
      format.fasta { send_data(sequences, filename: "pfitmap.fasta") }
      format.gb { send_data(sequences, filename: "pfitmap.gb") }

    end

  end
end
