class Locationable::CitiesController < LocationsController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_locationable

  def create
    super
  end

  def show
  end

  private
    def set_locationable
      @locationable = City.find(params[:city_id])
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
