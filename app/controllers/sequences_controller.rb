class SequencesController < ApplicationController
  def show
    @sequence = Sequence.find(params[:id])
  end
  
  def index
    @sequences = Sequence.paginate(page: params[:page])
  end
end
