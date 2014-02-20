class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET locations
  def index
    @locations = @locationable.locations
  end

  # GET locations/1
  def show
  end

  # GET locations/new
  def new
    @location = Location.new
  end

  # GET locations/1/edit
  def edit
  end

  # POST locations
  def create
    @location = @locationable.locations.build(location_params)

    if @location.save
      redirect_to [@locationable, @location], 
        notice: 'Location was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT locations/1
  def update
    if @location.update(location_params)
      redirect_to [@locationable, @location], 
        notice: 'Location was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE locations/1
  def destroy
    @location.destroy
    redirect_to polymorphic_url([@locationable, Location]), 
      notice: 'Location was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      params.require(:location).
        permit(:name, :address, :city, :country, :postal_code, :coordinates,
              :latitude, :longitude, :zoom_level)
    end
end
