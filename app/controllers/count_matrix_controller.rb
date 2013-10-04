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
    tax_levels = params[:taxon_level].in?(@tl) ? @tl.slice(0..@tl.index(params[:taxon_level])) : @tl[0]
    #Selecting which protein ranks to inlcude in the query
    prot_levels = params[:protein_level].in?(@pl) ? @pl.slice(0..@pl.index(params[:protein_level])) : @pl[0]

    @cm.release = @pfr.release
    @cm.taxon_level = tax_levels[-1]
    @cm.protein_level = prot_levels[-1]

    @cm.taxon_filter = params[:taxon_filter] ? params[:taxon_filter].split(",") : nil
    @cm.protein_filter = params[:protein_filter] ? params[:protein_filter].split(",") : nil

    if @cm.valid?

      filter_params = {release: @pfr.id}
      taxon_filter = ["taxons.pfitmap_release_id=:release"]
      protein_filter = []
      if !@cm.taxon_filter.blank?
        filter_params[:tax_filter] = @cm.taxon_filter
        taxon_filter.append("taxons.#{@cm.taxon_level} IN (:tax_filter)")
      end
      if !@cm.protein_filter.blank?
        filter_params[:prot_filter] = @cm.protein_filter
        protein_filter.append("proteins.#{@cm.protein_level} IN (:prot_filter)")
      end
      tax_genomes_counts = Taxon.select("#{tax_levels.map{|t| "taxons.#{t}"}.join(",")}, count(*) AS no_genomes").where(taxon_filter.join(" AND "),filter_params).group(tax_levels.map{|t| "taxons.#{t}"}.join(","))
      @countmt = {}
      tax_genomes_counts.each do |tgc|
        cmt = CountMatrixTaxon.new
        tax_levels.map{|t| cmt[t] = tgc[t]}
        cmt.no_genomes = tgc.no_genomes
        @countmt[cmt.hierarchy] = cmt
      end
      tax_protein_counts = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins, SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{tax_levels.map{|t| "taxons.#{t}"}.join(",")},#{prot_levels.map{|p| "proteins.#{p}"}.join(",")}").where((taxon_filter+protein_filter).join(" AND "),filter_params).group("#{tax_levels.map{|t| "taxons.#{t}"}.join(",")},#{prot_levels.map{|p| "proteins.#{p}"}.join(",")}")

      tax_protein_counts.each do |tpc| 
        cmtp = CountMatrixTaxonProtein.new
        taxon = @tl.map{|t| tpc[t] }.join(":")
        prot_levels.map{|p| cmtp[p] = tpc[p]}
        cmtp.no_proteins = tpc.no_proteins
        cmtp.no_genomes_with_proteins = tpc.no_genomes_with_proteins
        @countmt[taxon].proteins.append(cmtp)
      end
      @cm.taxons = @countmt

      #Set DOM variables to use in D3 Javascript
      gon.tax_columns = tax_levels
      gon.no_genomes_column = ["no_genomes"]
      gon.prot_columns = tax_protein_counts.map{ |t| t[@cm.protein_level]}.to_set.to_a.sort

      gon.columns = gon.tax_columns + gon.no_genomes_column + gon.prot_columns

      gon.count_matrix = @cm
    end
    if @cm.valid?
      respond_to do |format|
        format.html { render 'count_matrix' }
      end
    else
      respond_to do |format|
        format.html { render 'count_matrix' }
      end
    end
  end
end
