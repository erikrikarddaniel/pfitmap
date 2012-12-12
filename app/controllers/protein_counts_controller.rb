class ProteinCountsController < ApplicationController
  load_and_authorize_resource

  # GET /protein_counts_by_rank
  # GET /protein_counts_by_rank.json
  def with_enzymes
    @taxon_ranks = Taxon::RANKS
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end
    if @pfitmap_release
      @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])
      @level = 0
      
      if params[:taxon_rank]
        if not (params[:taxon_rank] == "All") 
          @taxon_rank = params[:taxon_rank]
          @taxons = Taxon.from_rank(params[:taxon_rank]).paginate(:page => params[:page])
        else
          @taxon_rank = nil
          @taxons = Taxon.order(:hierarchy).paginate(:page => params[:page])
        end
      else
        @taxon_rank = "superkingdom"
        @taxons = Taxon.from_rank("superkingdom").paginate(:page => params[:page])
      end

      @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, Protein.all, @pfitmap_release)
      respond_to do |format|
        format.html { render 'with_enzymes' }
        format.json { render json: @protein_counts }
        format.js { render partial: 'protein_counts/protein_counts_table', :locals => {:protein_counts => @protein_counts}, :content_type => 'text/html'}
      end
    else
      respond_to do |format|
        format.html { render 'with_enzymes' }
      end
    end
  end


  def add_row
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end
    @parent_taxon = Taxon.find(params[:parent_id])
    parent_level = params[:level]
    @level = Integer(parent_level) + 1
    @taxons = @parent_taxon.children.order('hierarchy DESC')
    @enzyme_tree, @parent_enzyme_ids, @enzymes = Enzyme.find_standard_enzymes(params[:enzyme_ids])

    @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, Protein.all, @pfitmap_release)
    respond_to do |format|
      format.js
    end
  end

  def collapse_rows
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end
    @level = Integer(params[:level])
    @parent_taxon = Taxon.find(params[:parent_id])
    @after_children_taxon = Taxon.where('parent_ncbi_id= ? AND hierarchy > ?', @parent_taxon.parent_ncbi_id, @parent_taxon.hierarchy).order("hierarchy").first 
    @taxons = @parent_taxon.children
    
    respond_to do |format|
      format.js
    end
  end
end
