class AdminController < ApplicationController
  def index
    @user = params[:user_id]
  end
end
