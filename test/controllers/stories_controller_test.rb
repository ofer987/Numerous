require 'test_helper'
require 'test_fileable'

class StoriesControllerTest < ActionController::TestCase
  include TestFileable

  def setup
    super
    setup_photo_files

    @article = {
      title: 'Halloween',
      sub_title: 'Dan meets Sina for first time in 2013',
      content: 'Sina stopped to be a douche for one day and ' +
        'agreed to leave his house to see Oren and Dan',
      published_at: DateTime.new(2013, 11, 2)
    }
  end

  def teardown
    teardown_photo_files
  end

  test "should get new_article" do
    get :new_article
    assert_response :success
  end

  test "should post new article and go to new_photo page" do
    assert_difference('Article.count', 1) do
      post :create_article, article: @article
    end

    assert_redirected_to "/stories/#{assigns(:article).id}/new_photo",
      'Did not redirect to Stories#NewPhoto'
  end

  test "should post new photo to existing article" do
    existing_article = articles(:cusco_trip)

    assert_difference('Photo.count', 1) do
      post :create_photo, {
        remote: true,
        article_id: existing_article.id,
        photo: { load_photo_file: self.photo_data }
      }
    end
  end
end
