require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  setup do
    @place = places(:rolls_23)
    @city = @place.city
    @country = @city.country
    @website = websites(:rolls_23_home)
  end

  test "should get index" do
    get :index, country: @country, city: @city, place: @place
    assert_response :success
    assert_not_nil assigns(:websites)

    assigns(:websites).each do |website|
      website.place.id == @place.id
    end
  end

  test "should get new" do
    get :new, country: @country, city: @city, place: @place
    assert_response :success
  end

  test "should create website" do
    assert_difference('Website.count') do
      post :create, country: @country, city: @city, place: @place, 
        website: { place_id: @website.place_id, 
                   url_type: @website.url_type, url: @website.url }
    end

    assert_redirected_to website_path(assigns(:website))
  end

  test "should show website" do
    get :show, id: @website, country: @country, city: @city, place: @place
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @website, country: @country, city: @city, place: @place
    assert_response :success
  end

  test "should update website" do
    patch :update, id: @website, country: @country, city: @city, 
      place: @place, website: { place_id: @website.place_id, 
                                url_type: @website.url_type, 
                                url: @website.url }
    assert_redirected_to website_path(assigns(:website))
  end

  test "should destroy website" do
    assert_difference('Website.count', -1) do
      delete :destroy, id: @website, country: @country, city: @city, 
        place: @place
    end

    assert_redirected_to websites_path
  end
end
