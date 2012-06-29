class SessionsController < ApplicationController
  authorize_resource :class => false
  def create
    save_release_choice = session[:release_id]
    reset_session # see http://guides.rubyonrails.org/security.html#session-fixation
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    if save_release_choice
      session[:release_id] = save_release_choice
    else
      session[:release_id] = nil
    end
    flash[:success] = "Signed in!"
    redirect_to :back
  end

  def failure
    redirect_to root_path :alert => 'Sorry, there was something wrong with your login attempt. Please try again.'
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:notice] = "You are now signed out!"
    redirect_to :back
  end

  #Method to control which pfitmap_release used all over the site
  #within a session
  def change_release
    @new_release = PfitmapRelease.find(params[:release_id])
    session[:release_id] = @new_release.id
    redirect_to :back
  end
end
