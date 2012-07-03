class StaticPagesController < ApplicationController
  authorize_resource :class => false
  def home
  end

  def help
  end
  
  def contact
  end

  def error_404
  end

  def sign_in
  end
end
