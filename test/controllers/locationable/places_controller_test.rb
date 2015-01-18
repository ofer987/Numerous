require 'controllers/locations_controller_test'
require 'test_helper'

class Locationable::PlacesControllerTest < ActionController::TestCase
  setup do
    @place = places(:freddo)
    @location = locations(:freddo_original)
    @locationable = @location.locationable
    @locationable_key = "#{@locationable.class.to_s.downcase}_id"
    @new_location = Location.new(address: '1 calle de parque calderon',
                                 city: 'Cuenca',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: @place,
                                 latitude: 12, 
                                 longitude: 45,
                                 zoom_level: 18,
                                 name: 'Tutto Freddo',
                                )
  end

  LocationsControllerTest.methods(false).each do |method|
    test method.to_s do
      LocationsControllerTest.send(method)
    end
  end
  # require LocationsControllerTest
  # require 'controllers/locations_controller_test'
end
