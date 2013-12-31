require 'test_helper'

class TagLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should find taglinks by tag name' do
    name = 'england'
    taglinks = TagLink.find_by_name(name)
    assert taglinks.count > 0
  end

  test 'should not find taglinks for non-existant tag name' do
    name = 'invalid_tag_name'
    assert TagLink.find_by_name(name).nil?
  end

  test 'should find taglinks by name through tag name' do
    name = 'england'
    tag = Tag[name]
    taglinks = TagLink.where(tag_id: tag.id)
    assert taglinks.count > 0
  end
end
