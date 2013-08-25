require 'test_helper'

class CommentTest < ActiveSupport::TestCase  
  test "comment should not be empty" do
    empty_comment = Comment.new
    assert empty_comment.invalid?, 'empty comments should not be allowed'
  end
  
  test "comment should belong to a commentable" do
    photoless_comment = Comment.new
    photoless_comment.commentable_id = rand(12345567) # Probably this id will not exist
    photoless_comment.commentable_type = 'Photo'
    photoless_comment.content = "nothing"
    photoless_comment.user = "Harold"
    
    assert photoless_comment.invalid?, 'comment should belong to a photo'
  end
end
