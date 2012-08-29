require 'test_helper'

class PhotoTagTest < ActiveSupport::TestCase
  #test "Join row should reference a valid photo and tag" do
  #  join = PhotoTag.new
  #  join.photo_id = rand(1234567)
  #  join.tag_id = tags(:toronto).id
  #  
  #  assert join.invalid?, "tag should belong to a valid tag"
  #  
  #  join = PhotoTag.new
  #  join.photo_id = photos(:eaton_college).id
  #  join.tag_id = rand(123455677)
  #  
  #  assert join.invalid?, "tag should belong to a valid photo"
  #end
  
  test "Join row should reference a non-nil photo and tag" do
    join = PhotoTag.new
    join.photo_id = nil
    join.tag_id = tags(:toronto).id
    
    assert join.invalid?, "tag_id is nil"
    
    join = PhotoTag.new
    join.photo_id = photos(:eaton_college).id
    join.tag_id = nil
    
    assert join.invalid?, "photo_id is nil"
  end
end
