class AdminController < ApplicationController
  def index
    @countries = Country.all
    @user = params[:user_id]
  end
end
