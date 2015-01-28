class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :get_logged_in
  before_action :authorize, :set_home_url

  protected

  def set_home_url
    @local_photos_dir = "/images/photos/"
    @photos_dir = "photos/"
    @images_dir = "application/"
  end

  def authorize
    # quick and dirty hack
    @is_logged_in = true

    unless @is_logged_in
      redirect_to login_url, notice: 'Please log in'
    end
  end

  private

  def get_logged_in
    @is_logged_in = User.find_by_id(session[:user_id])
  end
end
