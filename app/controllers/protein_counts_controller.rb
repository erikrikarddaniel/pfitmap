class ProteinCountsController < ApplicationController
  load_and_authorize_resource

  # GET /protein_counts_by_rank
  # GET /protein_counts_by_rank.json
  def by_rank
    @taxon_ranks = Taxon.all_ranks
    @proteins = Protein.all
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end

    if params[:protein_ids]
      @chosen_proteins = Protein.find_all_by_id(params[:protein_ids])
    else
      @chosen_proteins = Protein.find_all_by_id([1,2,3,4])
    end

    if params[:taxon_rank]
      @taxon_rank = params[:taxon_rank]
      @taxons = Taxon.from_rank(params[:taxon_rank]).paginate(:page => params[:page])
    else
      @taxon_rank = nil
      @taxons = Taxon.paginate(:page => params[:page])
    end

    @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, @chosen_proteins, @pfitmap_release)
    respond_to do |format|
      format.html
      format.json { render json: @protein_counts }
      format.js { render partial: 'protein_counts/protein_counts_table', :locals => {:protein_counts => @protein_counts}, :content_type => 'text/html'}
    end
  end

  def by_hierarchy
    @taxon_roots = Taxon.roots
    @proteins = Protein.all

    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end

    if params[:protein_ids]
      @chosen_proteins = Protein.find_all_by_id(params[:protein_ids])
    else
      @chosen_proteins = Protein.find_all_by_id([1,2,3,4])
    end

    if params[:parent_taxon_id]
      @parent_taxon = Taxon.find(params[:parent_taxon_id])
      @taxons = [@parent_taxon] + @parent_taxon.children
    else
      @taxons = @taxon_roots
    end

    @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, @chosen_proteins, @pfitmap_release)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protein_counts }
      format.js { render partial: 'protein_counts/protein_counts_table_hierarchy', locals: {taxons: @taxon_roots}, :content_type => 'text/html'}
    end
  end

  # GET /protein_counts_by_rank
  # GET /protein_counts_by_rank.json
  def with_enzymes
    @taxon_ranks = Taxon.all_ranks
    if session[:release_id]
      @pfitmap_release = PfitmapRelease.find(session[:release_id])
    else
      @pfitmap_release = PfitmapRelease.find_current_release
    end
    @enzymes = find_standard_enzymes
    @level = 0
    
    if params[:taxon_rank]
      @taxon_rank = params[:taxon_rank]
      @taxons = Taxon.from_rank(params[:taxon_rank]).paginate(:page => params[:page])
    else
      @taxon_rank = nil
      @taxons = Taxon.paginate(:page => params[:page])
    end

    @protein_counts_hash = ProteinCount.protein_counts_hash_for(@taxons, Protein.all, @pfitmap_release)
    respond_to do |format|
      format.html { render 'with_enzymes' }
      format.json { render json: @protein_counts }
      format.js { render partial: 'protein_counts/protein_counts_table', :locals => {:protein_counts => @protein_counts}, :content_type => 'text/html'}
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
    @taxons = @parent_taxon.children
    @enzymes = find_standard_enzymes

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
    @taxons = @parent_taxon.children
    
    respond_to do |format|
      format.js
    end
  end

  private
  def find_standard_enzymes
    enzymes = []
    name_array = ['RNR class I enzyme', 'RNR class Ib enzyme', 'RNR class II enzyme', 'RNR class III enzyme']
    name_array.each do |name|
      enz = Enzyme.find_by_name(name)
      if enz
        enzymes << enz
      end
    end
    return enzymes
  end
end
