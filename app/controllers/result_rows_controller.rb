class ResultRowsController < ApplicationController
  def show
    @result_row = ResultRow.find(params[:id])
    @result= Result.find(@result_row.result_id)
    @profile= Profile.find(@result.profile._id)
    @result_row_sequences = @result_row.result_rows_sequences.paginate(page: params[:page])
  end
end
