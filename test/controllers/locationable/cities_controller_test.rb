require 'test_helper'

class Locationable::CitiesControllerTest < ActionController::TestCase
  setup do
    @city = cities(:cuenca)
    @new_location = Location.new(address: '',
                                 city: 'Cuenca',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: @city,
                                 latitude: 19,
                                 longitude: 45,
                                 name: 'Cuenca',
                                )
  end

  test "should create location for city of Cuenca" do
    assert_difference('Location.count') do
      post :create, city_id: @city, location: { 
        locationable_id: @city,
        locationable_type: @city.class.to_s,
        address: @new_location.address, 
        city: @new_location.city, 
        latitude: @new_location.latitude, 
        longitude: @new_location.longitude,
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end

    assert_redirected_to [@city, assigns(:location)]
  end
end
