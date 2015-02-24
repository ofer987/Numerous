class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :get_logged_in
  before_action :set_main_bar
  before_action :authorize, :set_home_url

  protected

  def set_home_url
    @local_photos_dir = "/images/photos/"
    @photos_dir = "photos/"
    @images_dir = "application/"
  end

  def authorize
    unless @is_logged_in
      redirect_to login_url, notice: 'Please log in'
    end
  end

  private

  def get_logged_in
    @user = User.find_by_id(session[:user_id])
    @is_logged_in = !@user.nil?
  end

  def set_main_bar
    @main_bar = @is_logged_in ? 'layouts/mainbar/logged' : 'layouts/mainbar/general'
  end
end
