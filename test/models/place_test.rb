require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  test 'should convert description to markup' do
    place = Place.new(description: 'Hello World')

    assert place.description == '<p>Hello World</p>',
      'description was not converted to markup'
  end
end
