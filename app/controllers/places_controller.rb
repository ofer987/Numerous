class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :set_tree

  skip_before_action :authorize, only: [:index, :show]

  # GET /places
  def index
    @places = @city.places
  end

  # GET /places/1
  def show
  end

  # GET /places/new
  def new
    @place = @city.places.build
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  def create
    @place = @city.places.build(place_params)

    if @place.save
      redirect_to [@country, @city, @place], 
        notice: 'Place was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /places/1
  def update
    if @place.update(place_params)
      redirect_to [@country, @city, @place], 
        notice: 'Place was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /places/1
  def destroy
    @place.destroy
    redirect_to country_city_places_url(@country, @city), 
      notice: 'Place was successfully destroyed.'
  end

  private
    def set_tree
      @country = Country.find(params[:country_id])
      @city = City.find(params[:city_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def place_params
      params.require(:place).permit(:name, :place_type_id, :description,
                                    :home_url, :wikipedia_url)
    end
end
