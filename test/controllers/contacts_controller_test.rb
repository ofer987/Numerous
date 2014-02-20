require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:freddo_phone)
    @place = @contact.place
    @city = @place.city
    @country = @city.country
  end

  test "should get index" do
    get :index, country_id: @country, city_id: @city, place_id: @place
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new, country_id: @country, city_id: @city, place_id: @place
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, country_id: @country, city_id: @city, place_id: @place, contact: { contact_type_id: @contact.contact_type_id, directions: @contact.directions, info: @contact.info, name: @contact.name }
    end

    assert_redirected_to country_city_place_contact_path(@country, @city, @place, assigns(:contact))
  end

  test "should show contact" do
    get :show, country_id: @country, city_id: @city, place_id: @place, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, country_id: @country, city_id: @city, place_id: @place, id: @contact
    assert_response :success
  end

  test "should update contact" do
    patch :update, country_id: @country, city_id: @city, place_id: @place, id: @contact, contact: { contact_type_id: @contact.contact_type_id, directions: @contact.directions, info: @contact.info, name: @contact.name }
    assert_redirected_to country_city_place_contact_path(@country, @city, @place, assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, country_id: @country, city_id: @city, place_id: @place, id: @contact
    end

    assert_redirected_to country_city_place_contacts_path(@country, @city, @place)
  end
end
