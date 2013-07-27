class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_home_url
  
  before_filter :authorize

  protected

  def set_home_url
    @photos_dir = "/assets/photos/";
    @images_dir = "/assets/application/"
  end
  
  def authorize
    @is_logged_in = User.find_by_id(session[:user_id])
    unless @is_logged_in
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
