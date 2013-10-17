class CountMatrixController < ApplicationController
  load_and_authorize_resource
  def get_counts
    @tl = Taxon::TAXA
    @pl = Protein::PROT_LEVELS
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
    #Selecting which taxon ranks to include in the query
    @tax_levels = params[:taxon_level].in?(@tl) ? @tl.slice(0..@tl.index(params[:taxon_level])) : [@tl[0]]
    #Selecting which protein ranks to inlcude in the query
    @prot_levels = params[:protein_level].in?(@pl) ? @pl.slice(0..@pl.index(params[:protein_level])) : [@pl[0]]

    @cm.release = @pfr.release
    @cm.taxon_level = @tax_levels[-1]
    @cm.protein_level = @prot_levels[-1]

    if @cm.valid?

      filter_params = {release: @pfr.id}
      taxon_filter = ["taxons.pfitmap_release_id=:release"]
      protein_filter = []
      @tax_levels.each do |t|
        if t.in?(params)
          filter_params[t.to_sym] = params[t].split("(,)")
          taxon_filter.append("taxons.#{t} IN (:#{t.to_sym})")
        end
      end
      @prot_levels.each do |p|
        if p.in?(params)
          filter_params[p.to_sym] = params[p].split("(,)")
          protein_filter.append("proteins.#{p} IN (:#{p.to_sym})")
        end
      end
      tax_genomes_counts = Taxon.select("#{@tax_levels.map{|t| "taxons.#{t}"}.join(",")}, count(*) AS no_genomes").where(taxon_filter.join(" AND "),filter_params).group(@tax_levels.map{|t| "taxons.#{t}"}.join(",")).order(@tax_levels.map{|t|"taxons.#{t}" }.join(","))
      @countmt = {}
      tax_genomes_counts.each do |tgc|
        cmt = CountMatrixTaxon.new
        @tax_levels.map{|t| cmt[t] = tgc[t]}
        cmt.no_genomes = tgc.no_genomes
        @countmt[cmt.hierarchy] = cmt
      end
      tax_protein_counts = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins, SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{@tax_levels.map{|t| "taxons.#{t}"}.join(",")},#{@prot_levels.map{|p| "proteins.#{p}"}.join(",")}").where((taxon_filter+protein_filter).join(" AND "),filter_params).group("#{@tax_levels.map{|t| "taxons.#{t}"}.join(",")},#{@prot_levels.map{|p| "proteins.#{p}"}.join(",")}")

      tax_protein_counts.each do |tpc| 
        cmtp = CountMatrixTaxonProtein.new
        taxon = @tl.map{|t| tpc[t] }.join(":")
        @prot_levels.map{|p| cmtp[p] = tpc[p]}
        cmtp.no_proteins = tpc.no_proteins
        cmtp.no_genomes_with_proteins = tpc.no_genomes_with_proteins
        @countmt[taxon].proteins.append(cmtp.attributes)
      end
      @cm.taxons = @countmt.values.map{|c| c.attributes}

      #Set DOM variables to use in D3 Javascript
      gon.tax_columns = [@cm.taxon_level, "no_genomes"]
      gon.prot_columns = [filter_params[@cm.protein_level.to_sym], tax_protein_counts.map{ |t| t[@cm.protein_level]}].compact.reduce([],:|).to_set.delete(nil).to_a.sort
      gon.columns = gon.tax_columns + gon.prot_columns
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
end
