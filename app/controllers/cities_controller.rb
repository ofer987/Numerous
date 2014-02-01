class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  skip_before_action :authorize, only: [:index, :show]

  # GET /cities
  def index
    @country = Country.find(params[:country_id])
    @cities = @country.cities
  end

  # GET /cities/1
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
    @country = Country.find(params[:country_id])
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  def create
    @country = Country.find(params[:country_id])
    @city = @country.cities.build(city_params)

    if @city.save
      redirect_to [@country, @city], notice: 'City was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /cities/1
  def update
    @country = Country.find(params[:country_id])
    
    if @city.update(city_params)
      redirect_to [@country, @city], notice: 'City was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /cities/1
  def destroy
    @country = Country.find(params[:country_id])
    
    @city.destroy
    redirect_to country_cities_url(@country), notice: 'City was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
      @country = @city.country
    end

    # Only allow a trusted parameter "white list" through.
    def city_params
      params.require(:city).permit(:name)
    end
end
