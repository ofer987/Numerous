class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_tree

  # GET /contacts
  def index
    @contacts = @place.contacts
  end

  # GET /contacts/1
  def show
  end

  # GET /contacts/new
  def new
    @contact = @place.contacts.build
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = @place.contacts.build(contact_params)

    if @contact.save
      redirect_to [@country, @city, @place, @contact], notice: 'Contact was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      redirect_to [@country, @city, @place, @contact], notice: 'Contact was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    redirect_to country_city_place_contacts_url(@country, @city, @place), notice: 'Contact was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def set_tree
      @place = Place.find(params[:place_id])
      @city = City.find(params[:city_id])
      @country = Country.find(params[:country_id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:contact_type_id, :name, :directions, :direction_type, :info)
    end
end
