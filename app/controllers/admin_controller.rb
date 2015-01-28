class AdminController < ApplicationController
  def index
    @recipes = Recipe.all
    @countries = Country.all
  end
end
