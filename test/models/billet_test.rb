require 'test_helper'

class BilletTest < ActiveSupport::TestCase
  setup do
    @valid_billet = Billet.new do |billet|
      billet.title = "Interesting Story"
      billet.sub_title = "You Should Read This!"
      billet.content = "Lots of interesting things to read here."
      billet.published_at = DateTime.now
    end
  end

  test "should be able to modify an billet's published_at date" do
    new_billet = Billet.new(published_at: DateTime.new(2012, 5, 12).getutc)

    assert new_billet.save, "should be able to modify an billet's published_at datetime"
    assert new_billet.published_at.getutc == DateTime.new(2012, 5, 12).getutc, "the billet cannot save its selected datetime"
  end

  test "billet's default time published_at is now" do
    now_expected = DateTime.now.getutc
    new_billet = Billet.new

    assert new_billet.published_at.getutc.year == now_expected.year &&
               new_billet.published_at.getutc.month == now_expected.month &&
               new_billet.published_at.getutc.day == now_expected.day

    assert new_billet.valid?
  end

  test 'should save billet' do
    assert @valid_billet.save
  end

  test 'billet should have tags' do
    billet = articles(:cusco_trip)
    assert billet.tags.count == 1

    billet.tags << Tag['england']
    billet.tags << Tag.find_or_init_by_name('toronto')
    billet.save!

    assert billet.tags.count == 3
    assert billet.tags.find_by_name('england')
    assert billet.tags.find_by_name('toronto')
  end

  test 'should add tags when setting the tags_attributes property' do
    billet = Billet.new(title: 'new billet',
                          content: 'Hello from Canada')
    billet.tags_attributes =
      { tags_attributes: 'toronto , montreal, quebec city' }
    assert billet.tags.to_a[0].name == 'toronto'
    assert billet.tags.to_a[1].name == 'montreal'
    assert billet.tags.to_a[2].name == 'quebec city'
  end

  test 'should convert tag names to lower case' do
    billet = Billet.new
    billet.tags_attributes = { tags_attributes: 'Toronto' }
    assert billet.tags.to_a[0].name == 'toronto'
  end

  test 'billet content should be displayed in paragraph form' do
    billet = Billet.new(content: "Hello\nWorld")

    assert (billet.content =~ /<p>Hello\nWorld<\/p>\n/) >= 0,
      "billet's content was not converted to markdown"
  end

  test 'deleting an billet should set associated photos to billet_id = nil' do
    billet = articles(:cusco_trip)

    assert billet.photos.count > 0, 'billet should have photos in order to perform test'
    photos = billet.photos

    billet.destroy
    assert photos.count > 0, 'photos should not have been deleted'
  end
end
