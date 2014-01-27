class Locationable::CountriesController < LocationsController
  before_action :set_location, only: [:show]
  before_action :set_locationable

  def create
    super
  end

  def show
    @index_path = country_countries_path(@locationable)
    @edit_path = edit_country_country_path(@locationable, @location)
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
