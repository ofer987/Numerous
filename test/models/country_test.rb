require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test 'country has a non-blank name' do
    country = Country.new(name: 'Brazil')
    assert country.valid?, 'country with name should be valid'

    blank_country = Country.new(name: '')
    refute blank_country.valid?, "blank name should not be valid.\n" +
      blank_country.errors.full_messages.to_s

    nil_country = Country.new(name: nil)
    refute nil_country.valid?, 'nil name should not be valid'
  end

  test 'country name should be unique' do
    second_peru = Country.new(name: 'Peru')

    refute second_peru.valid?, 'Two countries should never share the same name'
  end
end
