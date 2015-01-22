require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @new_location = {
      address: '231 Hex Street',
      city: 'Orion City',
      latitude: 21,
      longitude: 23,
      zoom_level: 2,
      country: 'Orion',
      name: 'Place 1',
      postal_code: '32878'
    }

    @lima = cities(:lima)
  end
  # include ActionDispatch::Routing::PolymorphicRoutes

  # test "should get index" do
  #   get :index, @locationable_key => @locationable
  #   assert_response :success
  #   assert_not_nil assigns(:locations)
  # end

  # def self. new
  #   get :new, @locationable_key => @locationable
  #   assert_response :success
  # end

  test "should get new" do
    get :new, city_id: @lima
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count', 1) do
      post :create, place_id: @place, location: @new_location.merge({
        locationable_id: @place,
        locationable_type: @place.class.to_s
      })
    end

    assert_redirected_to [@place, assigns(:location)]
    assert assigns(:location).latitude == @new_location.latitude
    assert assigns(:location).longitude == @new_location.longitude
    assert assigns(:location).zoom_level == @new_location.zoom_level
  end

  test "should show location" do
    get :show, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location, @locationable_key => @locationable
    end

    assert_redirected_to polymorphic_path([@locationable, Location])
  end
end
