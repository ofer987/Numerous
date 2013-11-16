require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do    
    @commentless_photo = photos(:nobody_commented)
    @new_comment = {
      content: "Hello I am a new comment",
      user: "Dan"
    }
  end

  test "should create comment for photo" do
    assert_difference('Comment.count') do
      post :create, photo_id: @commentless_photo.id, comment: @new_comment
    end

    assert_redirected_to @commentless_photo
  end
  
  test "should create comment for article" do
    article = articles(:cusco_trip)
    
    assert_difference('Comment.count') do
      post :create, article_id: article.id, comment: @new_comment
    end

    assert_redirected_to article
  end

  test "should destroy comment for photo" do
    photo = photos(:eaton_college)
    comment = photo.comments.first

    assert_difference('Comment.count', -1) do
      delete :destroy, id: comment.to_param, photo_id: photo.id
    end
    
    assert_redirected_to root_path
  end
end
