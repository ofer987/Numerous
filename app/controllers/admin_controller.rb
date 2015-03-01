class AdminController < ApplicationController
  def index
    @user = User.find_by_username params[:username]
  end
end
