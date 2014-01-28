require 'test_helper'

class CityTest < ActiveSupport::TestCase
  test 'city should belong to a country' do
    city = City.new(name: 'toronto', country: nil)
    refute city.valid?, city.errors.full_messages
  end

  test 'destroying a city should delete places' do
    cuenca = cities(:cuenca)
    assert cuenca.places.size > 0, 
      'the city of cuenca should have at least one place'
    cuenca.destroy

    Place.all.each do |place|
      refute place.city == cuenca, 
        "oh no, cuenca's places have not been destroyed"
    end
  end
end
