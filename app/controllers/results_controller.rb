class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @profile = Profile.find(@result.profile_id)
  end
end
