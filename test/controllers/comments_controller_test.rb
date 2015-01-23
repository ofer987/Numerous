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

  test "should create comment for billet" do
    billet = articles(:cusco_trip)

    assert_difference('Comment.count') do
      post :create, billet_id: billet.id, comment: @new_comment
    end

    assert_redirected_to billet
  end
end
