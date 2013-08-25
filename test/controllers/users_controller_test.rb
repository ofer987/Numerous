require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:admin)
    
    @input_attributes = {
      name: "dan",
      password: "private",
      password_confirmation: "private"      
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @input_attributes
    end

    assert_redirected_to users_path
  end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user.to_param, user: @input_attributes
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to users_path
  end
  
  test "should never delete last user" do
    User.all.each do |user|
      delete :destroy, id: user.to_param
    end
    
    assert_equal 1, User.count
  end
end
