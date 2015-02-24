require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @commentless_article = articles(:avena)
    @new_comment = {
      content: "Hello I am a new comment",
      user: "Dan"
    }
  end

  test "should create comment for article" do
    assert_difference('Comment.count') do
      post :create, user_id: @commentless_article.user,
        article_id: @commentless_article.id, comment: @new_comment
    end

    assert_redirected_to @commentless_article
  end
end
