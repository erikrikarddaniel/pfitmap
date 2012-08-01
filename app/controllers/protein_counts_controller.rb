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

end
