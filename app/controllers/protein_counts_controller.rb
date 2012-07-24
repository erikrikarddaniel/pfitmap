class ProteinCountsController < ApplicationController
  load_and_authorize_resource
  # GET /protein_counts
  # GET /protein_counts.json
  def index
    if params[:rank]
      @protein_counts = ProteinCount.from_rank(params[:rank]).paginate(:page => params[:page])
    else
      @protein_counts = ProteinCount.paginate(:page => params[:page])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protein_counts }
    end
  end
end
