require 'test_helper'

class Locationable::PlacesControllerTest < ActionController::TestCase
  include ActionDispatch::Routing::PolymorphicRoutes

  setup do
    @place = places(:freddo)
    @location = locations(:freddo_original)
    @locationable = @location.locationable
    @locationable_key = "#{@locationable.class.to_s.downcase}_id"
    @new_location = Location.new(address: '1 calle de parque calderon',
                                 city: 'Cuenca',
                                 country: 'Ecuador',
                                 postal_code: '',
                                 locationable: @place,
                                 coordinates: "12, 45",
                                 name: 'Tutto Freddo',
                                )
  end

  test "should get index for place=cafe" do
    get :index, @locationable_key => @locationable
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new for place=cafe" do
    get :new, @locationable_key => @locationable
    assert_response :success
  end

  test "should create location for cafe Tutto Freddo" do
    assert_difference('Location.count') do
      post :create, place_id: @place,
        location: { 
        locationable_id: @place,
        locationable_type: @place.class.to_s,
        address: @new_location.address, 
        city: @new_location.city, 
        coordinates: @new_location.coordinates, 
        country: @new_location.country, 
        name: @new_location.name, 
        postal_code: @new_location.postal_code 
      }
    end

    assert_redirected_to [@place, assigns(:location)]
  end

  test "should show location" do
    get :show, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location, @locationable_key => @locationable
    assert_response :success
  end

  test "should destroy location for cafe" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location, @locationable_key => @locationable
    end

    assert_redirected_to polymorphic_path([@locationable, Location])
    # assert_redirected_to place_locations_path(@locationable)
  end
end
