require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  #test "tags are reusable for all photos" do
  #  new_tag_name = "London"
  #  
  #  # add a new tag
  #  puts "First Photo id = #{photos(:eaton_college).id}\n"
  #  eaton_college = photos(:eaton_college)
  #  new_tag = Tag.first_or_create(name: new_tag_name)
  #  puts "Tag = #{new_tag}\n, new_tag.id = #{new_tag.id}"
  #  eaton_college.tags.push(Tag.first_or_create(name: new_tag_name))
  #  first_tag = eaton_college.tags.first
  #  puts "first_tag.id = #{first_tag.id}\n"
  #  found_tag = eaton_college.tags.find_by_name(new_tag_name)
  #  puts "found_tag = #{found_tag}\n"
  #  
  #  current_tag_count = Tag.count
  #  
  #  # add a new tag, with the same name, to a different photo
  #  nobody_commented = photos(:nobody_commented)
  #  nobody_commented.tags.push(Tag.first_or_create(name: new_tag_name))
  #  
  #  puts "First Photo tag id #{eaton_college.tags.find_by_name(new_tag_name).id}\n"
  #  puts "Second Photo tag id #{nobody_commented.tags.find_by_name(new_tag_name).id}\n"
  #  
  #  # Since, the tag name is the same, then they should both use the same tag
  #  #assert_equal eaton_college.tags.find_by_name(new_tag_name).id, nobody_commented.tags.find_by_name(new_tag_name).id, "Both photos should have the same tag"
  #  
  #  # And the tag count should not have changed
  #  new_tag_count = Tag.count
  #  #assert_equal current_tag_count, new_tag_count, "A new tag should not have been created"
  #  assert true;
  #end
  
  test "destroying a tag should destroy the tag_links" do
    # The England tag is used by two photos
    tag = tags(:england)
    assert_difference('TagLink.count', -3) do
      tag.destroy
    end
  end

  test 'tag should not be deleted when deleted it from a tagable' do
    tag = tags(:england)
    photo = photos(:eaton_college)

    assert TagLink.where(tag_id: tag.id).count > 1,
      "The selected tag #{tag.name} is only used by 0 or 1 tagables"
    photo.tags.destroy(tag)
    refute photo.tags.find_by_id(tag.id), 'should have removed the tag'
    refute Tag.find_by_id(tag.id).nil?, 'Tag should not have been deleted'
  end
  
  test "tags are unique" do
    new_tag_with_same_name = Tag.create(name: 'quebec')
    
    assert new_tag_with_same_name.invalid?, 
      'tags should only have unique names'
  end

  test 'should init tag that does not exist' do
    name = 'new_tag'
    assert Tag.find_or_init_by_name(name).new_record?
  end
end
