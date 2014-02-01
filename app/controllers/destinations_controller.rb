class DestinationsController < ApplicationController
  skip_before_action :authorize, only: [:index]
  # Get distinations/
  def index
    @countries = Country.all
  end
end
