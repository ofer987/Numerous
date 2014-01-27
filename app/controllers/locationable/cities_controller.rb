class Locationable::CitiesController < LocationsController
  before_action :set_location, only: [:show]
  before_action :set_locationable

  def create
    super
  end

  def show
    @index_path = city_cities_path(@locationable)
    @edit_path = edit_city_city_path(@locationable, @location)
  end

  private
    def set_locationable
      @locationable = City.find(params[:city_id])
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
