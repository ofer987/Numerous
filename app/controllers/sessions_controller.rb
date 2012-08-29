class SessionsController < ApplicationController
  skip_before_filter :authorize, only: [:create, :new]
  
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, notice: "Invalid user name/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to photos_url
  end
end
