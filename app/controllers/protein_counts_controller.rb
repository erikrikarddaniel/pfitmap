class ProteinCountsController < ApplicationController
  load_and_authorize_resource
  # GET /protein_counts
  # GET /protein_counts.json
  def index
    @taxon_ranks = Taxon.all_ranks
    if params[:rank]
      @protein_counts = ProteinCount.from_rank(params[:rank]).paginate(:page => params[:page])
    else
      @protein_counts = ProteinCount.paginate(:page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protein_counts }
      format.js
    end
  end

  def protein_counts_by_taxons
    if params[:taxon_root_id]
      @taxon_root = Taxon.find_by_id(params[:taxon_root_id])
      @taxons = @taxon_root.children(:include => :protein_counts)
      @protein_counts = @taxons.map{ |t| t.protein_counts }
    else
      @taxon_roots = Taxon.roots
      logger.debug "blabla #{__FILE__}"
      logger.debug "blabla roots: #{@taxon_roots}"
      @taxons = @taxon_roots.map{ |tr| tr.children(:include => :protein_counts) }
      logger.debug "blabla taxons: #{@taxons}"
      @protein_counts = @taxons.map{ |trc| trc.map{ |t| t.protein_counts.all }}
      logger.debug "blabla protein_counts: #{@protein_counts}"
    end
    respond_to do |format|
      format.js 
      format.html { render 'index' }
    end
  end
end
