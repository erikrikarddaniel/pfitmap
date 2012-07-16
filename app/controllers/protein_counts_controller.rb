class ProteinCountsController < ApplicationController
  load_and_authorize_resource
  # GET /protein_counts
  # GET /protein_counts.json
  def index
    @protein_counts = ProteinCount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protein_counts }
    end
  end
end
