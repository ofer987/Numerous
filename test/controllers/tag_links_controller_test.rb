require 'test_helper'

class TagLinksControllerTest < ActionController::TestCase
  setup do
    @tag_link = tag_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag_link" do
    assert_difference('TagLink.count') do
      post :create, tag_link: { tag_id: @tag_link.tag_id, tagable_id: @tag_link.tagable_id, tagable_type: @tag_link.tagable_type }
    end

    assert_redirected_to tag_link_path(assigns(:tag_link))
  end

  test "should show tag_link" do
    get :show, id: @tag_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag_link
    assert_response :success
  end

  test "should update tag_link" do
    patch :update, id: @tag_link, tag_link: { tag_id: @tag_link.tag_id, tagable_id: @tag_link.tagable_id, tagable_type: @tag_link.tagable_type }
    assert_redirected_to tag_link_path(assigns(:tag_link))
  end

  test "should destroy tag_link" do
    assert_difference('TagLink.count', -1) do
      delete :destroy, id: @tag_link
    end

    assert_redirected_to tag_links_path
  end
end
