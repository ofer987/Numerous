class PlaceTypesController < ApplicationController
  before_action :set_place_type, only: [:show, :edit, :update, :destroy]

  # GET /place_types
  def index
    @place_types = PlaceType.all
  end

  # GET /place_types/1
  def show
  end

  # GET /place_types/new
  def new
    @place_type = PlaceType.new
  end

  # GET /place_types/1/edit
  def edit
  end

  # POST /place_types
  def create
    @place_type = PlaceType.new(place_type_params)

    if @place_type.save
      redirect_to @place_type, notice: 'Place type was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /place_types/1
  def update
    if @place_type.update(place_type_params)
      redirect_to @place_type, notice: 'Place type was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /place_types/1
  def destroy
    @place_type.destroy
    redirect_to place_types_url, notice: 'Place type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place_type
      @place_type = PlaceType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def place_type_params
      params.require(:place_type).permit(:name, :description)
    end
end
