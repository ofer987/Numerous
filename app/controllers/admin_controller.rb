class AdminController < ApplicationController
  def index
    @countries = Country.all
  end
end
