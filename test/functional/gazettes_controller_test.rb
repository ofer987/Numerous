require 'test_helper'

class GazettesControllerTest < ActionController::TestCase
  setup do
    @peru_stories_gazette = gazettes(:peru_stories)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gazette" do
    new_gazette = {
      name: "New Gazette",
      description: "Some Description"
    }
    
    assert_difference('Gazette.count') do
      post :create, gazette: new_gazette
    end
    
    assert_redirected_to gazette_path(assigns(:gazette))
  end
  
  test "should get edit" do
    get :edit, id: @peru_stories_gazette
    assert_response :success
  end
  
  test "should update gazette" do
    put :update, id: @peru_stories_gazette, gazette: { description: 'This is an awesome collection of stories' }
    assert_redirected_to gazette_path(assigns(:gazette))
  end
  
  test "should delete gazette and all sub-articles" do
    delete :destroy, id: @peru_stories_gazette
    assert_redirected_to gazettes_url
    
    assert Gazette.where(id: @peru_stories_gazette).count == 0, 'The peru story should have been deleted'
    assert Article.where(gazette_id: @peru_stories_gazette).count == 0, 'The peru sub-stories should have been deleted'
  end
end