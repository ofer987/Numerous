require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test 'should create a full address' do
    oren_home = Location.new do |loc|
      loc.address = "249 Tansley Road"
      loc.city = "Thornhill"
      loc.province = "Ontario"
      loc.postal_code = "L4J 2V9"
      loc.country = "Canada"
    end

    assert oren_home.full_address == "#{oren_home.address}\n" +
      "#{oren_home.city}, #{oren_home.province}\n" +
      "#{oren_home.postal_code}\n" +
      "#{oren_home.country}",
      "Location.full_address is not implemented correctly"
  end
end
