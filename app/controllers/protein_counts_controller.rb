class ProteinCountsController < ApplicationController
  load_and_authorize_resource

  # GET /protein_counts_by_rank
  # GET /protein_counts_by_rank.json
  def with_enzymes
    @taxon_ranks = Taxon.all_ranks
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end
    if @pfitmap_release
      [@enzyme_tree, @parent_enzyme_ids] = find_standard_enzymes(params[:enzyme_ids])
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
    [@enzyme_tree, @parent_enzyme_ids, @enzymes] = find_standard_enzymes(params[:enzyme_ids])

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
    @after_children_taxon = Taxon.where('rank = ? AND hierarchy > ?', @parent_taxon.rank, @parent_taxon.hierarchy).order("hierarchy").first 
    @taxons = @parent_taxon.children
    
    respond_to do |format|
      format.js
    end
  end

  private
  def find_standard_enzymes(enzyme_ids)
    parent_ids = 
    if enzyme_ids
      enzymes = Enzyme.find(enzyme_ids, :order => "parent_id, name")
      enzyme_tree = build_tree_from(enzymes, {})
      parent_ids = Enzyme.find(enzyme_ids, :order => "name", :condition => "parent_id IS NULL")
    else
      enzymes = Enzyme.find_all_by_parent_id(nil, :order => "name")
      parent_ids = 
      [enzyme_tree, parent_ids] = build_tree_from(enzymes, {})
    end
  end
  
  # All enzymes are sorted on the parent_id
  # so the root enzymes will come first
  def build_tree_from(enzymes)
    tree = {}
    enzyme_hash = {}
    parent_ids = []
    enzymes.each do |e|
      enzyme_hash[e.id] = true
      if not e.parent_id
        parent_ids << e.id
      end
    end
    
    enzymes.each do |e|
      children = []
      e.children.each do |c|
        if enzyme_hash[c.id]
          children << c.id
        end
      end
      tree[e.id] = [e, children, e.proteins]
    end
    return [tree, parent_ids, enzymes]
  end
end
