require 'test_helper'

class Locationable::CountriesControllerTest < ActionController::TestCase
  setup do
    @country = countries(:ecuador)
    @new_location = Location.new(address: '',
                                 city: '',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: @country,
                                 latitude: 12, 
                                 longitude: 45,
                                 name: 'Ecuador',
                                )
  end

  test "should create location for Ecuador" do
    assert_difference('Location.count') do
      post :create, country_id: @country, location: { 
        locationable_id: @country,
        locationable_type: @country.class.to_s,
        address: @new_location.address, 
        city: @new_location.city, 
        latitude: @new_location.latitude, 
        longitude: @new_location.longitude,
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end

    assert_redirected_to [@country, assigns(:location)]
  end

end
