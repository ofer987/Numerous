require 'test_helper'

class CitiesControllerTest < ActionController::TestCase
  setup do
    @city = cities(:cuenca)
    @country = @city.country
  end

  test "should get index" do
    get :index, country_id: @country.id
    assert_response :success
    assert_not_nil assigns(:cities)
  end

  test "should get new" do
    get :new, country_id: @country.id
    assert_response :success
  end

  test "should create city" do
    assert_difference('City.count') do
      post :create, country_id: @country.id, city: { name: 'Quito' }
    end

    assert_redirected_to country_city_path(@country.id, assigns(:city))
  end

  test "should show city" do
    get :show, id: @city, country_id: @country
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @city, country_id: @country
    assert_response :success
  end

  test "should update city" do
    patch :update, id: @city, city: { name: 'Parque del Cajas' }
    assert_redirected_to country_city_path(@country, assigns(:city))
  end

  test "should destroy city" do
    assert_difference('City.count', -1) do
      delete :destroy, id: @city
    end

    assert_redirected_to country_cities_path(@country)
  end
end
