require 'test_helper'
require 'test_fileable'

class StoriesControllerTest < ActionController::TestCase
  include TestFileable

  def setup
    super
    setup_photo_files
    
    @article = {
      gazette_id: gazettes(:peru_stories).to_param,
      title: 'Halloween',
      sub_title: 'Dan meets Sina for first time in 2013',
      content: 'Sina stopped to be a douche for one day and agreed to leave his house to see Oren and Dan',
      published_at: DateTime.new(2013, 11, 2)
    }
  end
  
  def teardown
    teardown_photo_files
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should post new photoless story" do
    post :create, article: @article
    assert_redirected_to assigns(:article)
  end

  test "should post new story with one photo" do
    @article['photos_attributes'] = { load_photo_files: [ photo_data ] }
    
    assert_difference('Photo.count', 1) do
      post :create, article: @article
    end
    assert_redirected_to assigns(:article)
  end
  
  test "should post new story with two photos" do
    @article['photos_attributes'] = { load_photo_files: [ self.photo_data, self.photo_data ] }
    
    assert_difference('Photo.count', 2) do
      post :create, article: @article
    end
    assert_redirected_to assigns(:article)
  end

end
