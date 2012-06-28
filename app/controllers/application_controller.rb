class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :header_releases, :session_release
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  #Header methods, to generate the release options in the header
  ## header_session_release returns the release given by the session or
  ## the current release as default.
  def session_release
    session[:release_id] ? PfitmapRelease.find_by_id(session[:release_id]) : PfitmapRelease.find_current_release
  end
  
  def header_releases
    PfitmapRelease.all(:order => "release", :limit => '5')
  end
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user_admin?
    current_u = current_user
    return ((current_u =! nil) && (current_u.role == 'admin'))
  end
end
