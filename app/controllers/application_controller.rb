class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user_admin?
    current_u = current_user
    return ((current_u =! nil) && (current_u.role == 'admin'))
  end
end
