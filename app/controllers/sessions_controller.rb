class SessionsController < ApplicationController
  def create
    reset_session # see http://guides.rubyonrails.org/security.html#session-fixation
    info = request.env["omniauth.auth"]
    sessions[:name] = info["user_info"]["name"] || info["user_info"]["email"] || info["user_info"]["nickname"] || "unknown friend"

    redirect_to root, :notice => "Welcome #{session[:name]}!"
   
  end

  def failure
    redirect_to login_url :alert => 'Sorry, there was something wrong with your login attempt. Please try again.'
  end

  def destroy
    reset_session
    flash[:notice] = "Logged out."
    redirect_to root
  end
end
