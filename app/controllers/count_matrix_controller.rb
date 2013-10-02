class CountMatrixController < ApplicationController
  load_and_authorize_resource
  def get_counts
    p = params[:count_matrix] ? Hash[*params[:count_matrix].split("/")] : {}
    if p["release"]
      p["release"].sub!("_",".")
      @pfr = PfitmapRelease.find(:first, conditions: {release: p["release"]})
    elsif session[:release_id]
      @pfr = PfitmapRelease.find(session[:release_id])
      p["release"] = @pfr.release
    else
      @pfr = PfitmapRelease.find_current_release
      p["release"] = @pfr.release
    end
    @cm = CountMatrix.new(p)
    
    if @cm.valid?
      
      @tl = Taxon::TAXA
      @pl = Protein::PROT_LEVELS


#    if @pfitmap_release
#      @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
#      @level = 0
      #Selecting which taxon ranks to include in the query and putting it on gon which is accessible in the DOM
      gon.tax_levels = @cm.taxon_level ? @tl.slice(0..@tl.index(@cm.taxon_level)) : @tl[0]
#      #Selecting which protein ranks to inlcude in the query and putting it on the gon which is accessible in the DOM
      gon.prot_levels = @cm.protein_level ? @pl.slice(0..@pl.index(@cm.protein_level)) : @pl[0]

      filter = ["pfitmap_release_id=:release"]
      filter_params = {release: @pfr.id}
      if !@cm.taxon_filter.blank?
        filter.append(":tax_level IN [:tax_filter]")
        filter_params[:tax_level] = @cm.taxon_level
        filter_params[:tax_filter] = @cm.taxon_filter
      end
      if !@cm.protein_filter.blank?
        filter.append(":prot_level IN [:prot_filter]")
        filter_params[:prot_level] = @cm.protein_level
        filter_params[:prot_filter] = @cm.protein_filter
      end
      filter = filter.join(" AND ")
byebug
      tax_genomes_counts = Taxon.joins(:protein_counts).select("#{gon.tax_levels.join(",")}, count(*) AS n_genomes").where(filter,filter_params).group(gon.tax_levels.join(","))
      tax_protein_counts = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins, SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{gon.tax_levels.join(",")},#{gon.prot_levels.join(",")}").where(filter,filter_params).group("#{gon.tax_levels.join(",")},#{gon.prot_levels.join(",")}")
      gon.tax_genomes_counts = tax_genomes_counts     
#      gon.taxons_proteins_protein_counts = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins,SUM(no_genomes) AS no_genomes,SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{gon.protein_rank.join(",")},#{gon.taxon_rank.join(",")}").where("pfitmap_release_id=#{@pfitmap_release.id}").group("#{gon.taxon_rank.join(",")},#{gon.protein_rank.join(",")}")
#
#      #get unique proteins to use as columns
#      gon.proteins=gon.taxons_proteins_protein_counts.map {|tppc| tppc[gon.protein_rank[-1]]}.to_set.to_a.sort
#
#      #All columns sent over to the vie + gon.proteinsw
#      gon.columns = gon.taxon_rank + gon.protein_sums + gon.proteins
#
#
#
#
#
#
#
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
