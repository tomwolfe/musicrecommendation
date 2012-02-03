class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery
  
  def authenticate_user!
    if current_user.nil?
      redirect_to login_url, :alert => "You must first log in to access this page"
    end
  end


end
