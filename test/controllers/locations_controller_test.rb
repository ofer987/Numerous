require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
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

  def self.new
    get :new, @locationable_key => @locationable
    assert_response :success
  end

  def self.create 
    assert_difference('Location.count') do
      post :create, place_id: @place,
        location: { 
        locationable_id: @place,
        locationable_type: @place.class.to_s,
        address: @new_location.address, 
        city: @new_location.city, 
        latitude: @new_location.latitude, 
        longitude: @new_location.longitude,
        zoom_level: @new_location.zoom_level,
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end

    assert_redirected_to [@place, assigns(:location)]
    assert assigns(:location).latitude == @new_location.latitude
    assert assigns(:location).longitude == @new_location.longitude
    assert assigns(:location).zoom_level == @new_location.zoom_level
  end

  def self.show
    get :show, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  def self.edit
    get :edit, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  def self.destroy 
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location, @locationable_key => @locationable
    end

    assert_redirected_to polymorphic_path([@locationable, Location])
  end
end
