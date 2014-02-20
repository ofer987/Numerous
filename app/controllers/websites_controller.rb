class WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :edit, :update, :destroy]
  before_action :set_tree

  # GET /websites
  def index
    @websites = @place.websites
  end

  # GET /websites/1
  def show
  end

  # GET /websites/new
  def new
    @website = @place.websites.build
  end

  # GET /websites/1/edit
  def edit
  end

  # POST /websites
  def create
    @website = @place.websites.build(website_params)

    if @website.save
      redirect_to [@country, @city, @place, @website], notice: 'Website was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /websites/1
  def update
    if @website.update(website_params)
      redirect_to [@country, @city, @place, @website], notice: 'Website was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /websites/1
  def destroy
    @website.destroy
    redirect_to websites_url, notice: 'Website was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_website
      @website = Website.find(params[:id])
    end

    def set_tree
      @country = Country.find(params[:country_id])
      @city = City.find(params[:city_id])
      @place = Place.find(params[:place_id])
    end

    # Only allow a trusted parameter "white list" through.
    def website_params
      params.require(:website).permit(:place_id, :url, :url_type)
    end
end
