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
    
    assert join.valid?, "the photo_id might be nil in order to allow tags to new photos before they are saved to the database"
    
    join = PhotoTag.new
    join.photo_id = photos(:eaton_college).id
    join.tag_id = nil
    
    assert join.invalid?, "the tag_id should not be nil"
  end
end
