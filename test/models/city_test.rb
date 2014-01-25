require 'test_helper'

class CityTest < ActiveSupport::TestCase
  test 'city should belong to a country' do
    city = City.new(name: 'toronto', country: nil)
    refute city.valid?, city.errors.full_messages
  end
end
