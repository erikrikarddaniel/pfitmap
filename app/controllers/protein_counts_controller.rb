class ProteinCountsController < ApplicationController
  load_and_authorize_resource

#  # GET /protein_counts_by_rank
#  # GET /protein_counts_by_rank.json
#  def with_enzymes
#    @taxon_ranks = Taxon::TAXA
#    if session[:release_id]
#      @pfitmap_release = PfitmapRelease.find(session[:release_id])
#    else
#      @pfitmap_release = PfitmapRelease.find_current_release
#    end
#    if @pfitmap_release
#      @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
#      @level = 0
#      #Selecting which taxon ranks to include in the query and putting it on gon which is accessible in the DOM
#      gon.taxon_rank = params[:taxon_rank] ? @taxon_ranks.slice(0..params[:taxon_rank]) : ["domain"]
#      #Selecting which protein ranks to inlcude in the query and putting it on the gon which is accessible in the DOM
#      #TODO make it select similar to taxon_ranks
#      gon.protein_rank = params[:protein_rank] ? ["protclass"] : ["protclass"]
#      gon.protein_sums =  ["no_genomes"]
#       
#      gon.taxons_proteins_protein_counts = ProteinCount.joins(:protein,:taxon).select("SUM(no_proteins) AS no_proteins,SUM(no_genomes) AS no_genomes,SUM(no_genomes_with_proteins) AS no_genomes_with_proteins,#{gon.protein_rank.join(",")},#{gon.taxon_rank.join(",")}").where("pfitmap_release_id=#{@pfitmap_release.id}").group("#{gon.taxon_rank.join(",")},#{gon.protein_rank.join(",")}")
#      
#      #get unique proteins to use as columns
#      gon.proteins=gon.taxons_proteins_protein_counts.map {|tppc| tppc[gon.protein_rank[-1]]}.to_set.to_a.sort
#      
#      #All columns sent over to the vie + gon.proteinsw
#      gon.columns = gon.taxon_rank + gon.protein_sums + gon.proteins
#      
#      respond_to do |format|
#        format.html { render 'with_enzymes' }
#        format.json { render json: @taxons_proteins_protein_counts }
#        format.js { render partial: 'protein_counts/protein_counts_table', :locals => {:taxons_proteins_protein_counts => @taxons_proteins_protein_counts}, :content_type => 'text/html'}
#      end
#    else
#      respond_to do |format|
#        format.html { render 'with_enzymes' }
#      end
#    end
#  end


#  def add_row
#    if session[:release_id]
#      @pfitmap_release = PfitmapRelease.find(session[:release_id])
#    else
#      @pfitmap_release = PfitmapRelease.find_current_release
#    end
#    @parent_taxon = Taxon.find(params[:parent_id])
#    parent_level = params[:level]
#    @level = Integer(parent_level) + 1
#    @taxons = @parent_taxon.children.order('hierarchy DESC')
#    @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
#
#    @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, Protein.all, @pfitmap_release)
#    respond_to do |format|
#      format.js
#    end
#  end
#
#  def collapse_rows
#    if session[:release_id]
#      @pfitmap_release = PfitmapRelease.find(session[:release_id])
#    else
#      @pfitmap_release = PfitmapRelease.find_current_release
#    end
#    @level = Integer(params[:level])
#    @parent_taxon = Taxon.find(params[:parent_id])
#    @after_children_taxon = Taxon.where('parent_ncbi_id= ? AND hierarchy > ?', @parent_taxon.parent_ncbi_id, @parent_taxon.hierarchy).order("hierarchy").first 
#    @taxons = @parent_taxon.children
#    @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
#    
#    respond_to do |format|
#      format.js
#    end
#  end
end
