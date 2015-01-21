require 'test_helper'

class PlacesControllerTest < ActionController::TestCase
  setup do
    @place = places(:freddo)
    @city = @place.city
    @country = @city.country
  end

  test "should get index" do
    get :index, city_id: @city, country_id: @country
    assert_response :success
    assert_not_nil assigns(:places)

    assigns(:places).each do |place|
      assert place.city_id == @city.id,
        "Place#index displays places for wrong country/city"
    end
  end

  test "should get new" do
    get :new, city_id: @city, country_id: @country
    assert_response :success
    assert assigns(:place).city.id == @city.id,
      "the new place should belong to a city"
  end

  test "should create place" do
    description = 'This is a beautiful place'

    assert_difference('Place.count') do
      post :create, city_id: @city, country_id: @country,
        place: {
        name: @place.name,
        place_type_id: @place.place_type_id,
        description: description
      }
    end

    assert_redirected_to country_city_place_path(@country, @city,
                                                assigns(:place))
    assert assigns(:place).name == @place.name,
      "place's name was not set"
    assert assigns(:place).place_type_id == @place.place_type_id,
      "place's place_type_id was not set"
  end

  test "should show place" do
    get :show, id: @place, city_id: @city, country_id: @country
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @place, city_id: @city, country_id: @country
    assert_response :success
  end

  test "should update place" do
    patch :update, id: @place, city_id: @city, country_id: @country,
      place: {
      name: @place.name,
      place_type_id: @place.place_type_id
    }
    assert_redirected_to country_city_place_path(@country,
                                                 @city, assigns(:place))
  end

  test "should destroy place" do
    assert_difference('Place.count', -1) do
      delete :destroy, id: @place, city_id: @city, country_id: @country
    end

    assert_redirected_to country_city_places_path(@country, @city)
  end
end
