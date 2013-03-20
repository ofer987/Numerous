require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    #@comment = comments(:one)
    
    @commentless_photo = photos(:nobody_commented)
    @new_comment = {
      content: "Hello I am a new comment",
      user: "Dan",
      photo_id: @commentless_photo.id
    }
  end

  test "should create comment" do
    #puts "kaka: #{Comment.count}\n"
    #puts "All the photos: #{Photo.all}\n"
    #puts "All the photo ids: #{Photo.all.map { |photo| photo.id }}\n"
    #puts "All the comments: #{Comment.all}\n"
    comment = Comment.create(content: "Hello I am a new comment", user: "Dan", photo_id: @commentless_photo.id)
    #puts "But the comment's photo is #{comment.photo}, #{comment.photo.id}\n"
    #puts "Errors: #{comment.errors.full_messages}\n"
    #puts "blah: #{Comment.count}\n"
    
    #puts "Photo title is #{@commentless_photo.title}\n"
    
    assert_difference('Comment.count') do
      post :create, photo_id: @commentless_photo.id, comment: @new_comment
    end

    assert_redirected_to photo_path(@commentless_photo)
  end

  #test "should get edit" do
  #  get :edit, id: @comment.to_param
  #  assert_response :success
  #end
  
  #test "should update comment" do
  #  put :update, id: @comment.to_param, comment: @comment.attributes
  #  assert_redirected_to comment_path(assigns(:comment))
  #end

  test "should destroy comment" do
    photo = photos(:eaton_college)
    comment = photo.comments.first
    #comment = comments(:eaton_college_comment)
    #puts "content = #{comment.content}, user = #{comment.user}\n"
    
    assert_difference('Comment.count', -1) do
      delete :destroy, photo_id: photo.id, id: comment.to_param
    end
    
    assert_redirected_to photo_path(photo)
  end
end
