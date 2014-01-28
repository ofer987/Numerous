class Locationable::CountriesController < LocationsController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_locationable

  def create
    super
  end

  def show
  end

  private
    def set_locationable
      country = Country.find(params[:country_id])
      @locationable = country
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
