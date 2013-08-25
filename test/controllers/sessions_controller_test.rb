require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    # Do not login automatically in the ActiveSupport::TestCase.setup
    # We want to test to login/logout functionality separately
    @manual_login = true
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    admin_user = users(:admin)
    post :create, name: admin_user.name, password: 'The_Password1'
    assert_redirected_to admin_url
    assert_equal admin_user.id, session[:user_id]
  end
  
  test "should fail login" do
    admin_user = users(:admin)
    post :create, name: admin_user.name, password: 'The_wrong_password!'
    assert_redirected_to login_url
  end

  test "should logout" do
    # log in first
    admin_user = users(:admin)
    post :create, name: admin_user.name, password: 'The_Password1'
    
    # now log out
    delete :destroy
    assert_redirected_to photos_url
  end

end
