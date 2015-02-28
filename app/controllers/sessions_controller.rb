class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:create, :new]

  def new
  end

  def create
    user = User.find_by_username(params[:username])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_admin_index_url(user)
    else
      redirect_to login_url, notice: "Invalid user name/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
