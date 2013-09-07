class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_action :set_home_url
  
  before_action :authorize

  protected

  def set_home_url
    @photos_dir = "photos/"
    @images_dir = "application/"
  end
  
  def authorize
    @is_logged_in = User.find_by_id(session[:user_id])
    unless @is_logged_in
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
