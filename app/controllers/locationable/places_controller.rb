class Locationable::PlacesController < LocationsController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_locationable

  def create
    super
  end

  def show
  end

  private
    def set_locationable
      @locationable = Place.find(params[:place_id])
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
