require 'test_helper'

class CityTest < ActiveSupport::TestCase
  test 'city should belong to a country' do
    city = City.new(name: 'toronto', country: nil)
    refute city.valid?, city.errors.full_messages
  end

  test 'destroying a city should delete places' do
    city = cities(:cuenca)
    city.destroy

    assert Place.find_by_city_id(city.id).size == 0,
      'did not delete the places associated with this city'
  end
end
