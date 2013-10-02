class CountMatrixController < ApplicationController
  load_and_authorize_resource
  def get_counts
    p = params[:count_matrix] ? Hash[*params[:count_matrix].split("/")] : {}
    if p["release"]
      p["release"].sub!("_",".")
    elsif session[:release_id]
      p["release"] = PfitmapRelease.find(session[:release_id]).release
    else
      p["release"] = PfitmapRelease.find_current_release.release
    end
    @cm = CountMatrix.new(p)
    p = {"release" => @cm.release}
    
    if @cm.valid? 
      
      @taxon_ranks = Taxon::TAXA



#    if @pfitmap_release
#      @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
#      @level = 0
      #Selecting which taxon ranks to include in the query and putting it on gon which is accessible in the DOM
      gon.taxon_rank = params[:taxon_rank] ? @taxon_ranks.slice(0..@taxon_ranks.index(params[:taxon_rank])) : ["domain"]
#      #Selecting which protein ranks to inlcude in the query and putting it on the gon which is accessible in the DOM
#      #TODO make it select similar to taxon_ranks
      gon.protein_rank = params[:protein_rank] ? ["protclass"] : ["protclass"]

      a = Taxon.select("#{tax_level.join(",")}, count(*) AS n_genomes").group(tax_level.join(","))
      b = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins,SUM(no_genomes) AS no_genomes,SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{tax_level.join(",")},#{prot_level.join(",")}").group("#{tax_level.join(",")},#{prot_level.join(",")}")
            

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
