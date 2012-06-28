class SessionsController < ApplicationController
  authorize_resource :class => false
  def create
    reset_session # see http://guides.rubyonrails.org/security.html#session-fixation
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    release = PfitmapRelease.find_current_release()
    if release != nil
      session[:release_id] = release.id
    else
      session[:release_id] = nil
    end
    redirect_to root_path, :notice => "Signed in!"
  end

  def failure
    redirect_to root_path :alert => 'Sorry, there was something wrong with your login attempt. Please try again.'
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:notice] = "You are now signed out!"
    redirect_to root_path
  end
end
