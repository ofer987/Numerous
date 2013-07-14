require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  setup do
    @cusco_trip_article = articles(:cusco_trip)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
