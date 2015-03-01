require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup do
    @edith = users(:edith)
  end

  test "should get index" do
    get :index, username: @edith.username
    assert_response :success
  end
end
