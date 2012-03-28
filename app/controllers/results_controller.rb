class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @profile = Profile.find(@result.profile_id)
    @result_rows = @result.result_rows.paginate(page: params[:page])
  end
end
