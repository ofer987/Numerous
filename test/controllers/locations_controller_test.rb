require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:ecuador)
    @new_location = Location.new(address: '1 calle de parque calderon',
                                 city: 'Cuenca',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: places(:freddo),
                                 coordinates: "12, 45",
                                 name: 'Tutto Freddo',
                                )
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should fail to create a location when locationable not specified" do
    assert_raises(ActionController::UrlGenerationError) do
      post :create, 
        location: { 
        locationable_id: nil,
        locationable_type: 'Place',
        address: @new_location.address, 
        city: @new_location.city, 
        coordinates: @new_location.coordinates, 
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end
  end

  test "should show location" do
    get :show, id: @location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location
    assert_response :success
  end

  test "should update location" do
    patch :update, id: @location, location: { 
      address: @new_location.address, 
      city: @new_location.city, 
      coordinates: @new_location.coordinates, 
      country: @new_location.country, 
      name: @new_location.name, 
      postal_code: @new_location.postal_code 
    }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location
    end

    assert_redirected_to locations_path
  end
end
