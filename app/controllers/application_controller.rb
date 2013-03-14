class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_home_url
  
  before_filter :authorize

  protected

  def set_home_url
    @photos_dir = "/assets/photos/";
  end
  
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
