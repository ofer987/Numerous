class DestinationsController < ApplicationController
  # Get distinations/
  def index
    @countries = Country.all
  end
end
