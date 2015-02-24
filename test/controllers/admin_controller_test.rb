require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup do
    @edith = users(:edith)
  end

  test "should get index" do
    get :index, user_id: @edith
    assert_response :success
  end
end
