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
  end

  test "should get new" do
    get :new, city_id: @city, country_id: @country
    assert_response :success
  end

  test "should create place" do
    assert_difference('Place.count') do
      post :create, city_id: @city, country_id: @country,
        place: { 
        name: @place.name, 
        place_type_id: @place.place_type_id 
      }
    end

    assert_redirected_to country_city_place_path(@country, @city,
                                                assigns(:place))
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
