require 'test_helper'

class BilletsControllerTest < ActionController::TestCase
  setup do
    @billet = billets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:billets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create billet" do
    assert_difference('Billet.count') do
      post :create, billet: {  }
    end

    assert_redirected_to billet_path(assigns(:billet))
  end

  test "should show billet" do
    get :show, id: @billet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @billet
    assert_response :success
  end

  test "should update billet" do
    patch :update, id: @billet, billet: {  }
    assert_redirected_to billet_path(assigns(:billet))
  end

  test "should destroy billet" do
    assert_difference('Billet.count', -1) do
      delete :destroy, id: @billet
    end

    assert_redirected_to billets_path
  end
end
