require 'test_helper'

class Locationable::PlacesControllerTest < ActionController::TestCase
  setup do
    @place = places(:freddo)
    @new_location = Location.new(address: '1 calle de parque calderon',
                                 city: 'Cuenca',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: @place,
                                 coordinates: "12, 45",
                                 name: 'Tutto Freddo',
                                )
  end

  test "should create location for cafe Tutto Freddo" do
    assert_difference('Location.count') do
      post :create, place_id: @place,
        location: { 
        locationable_id: @place,
        locationable_type: @place.class.to_s,
        address: @new_location.address, 
        city: @new_location.city, 
        coordinates: @new_location.coordinates, 
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end

    assert_redirected_to [@place, assigns(:location)]
  end
end
