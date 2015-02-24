require 'test_helper'
require 'test_fileable'

class PhotoTest < ActiveSupport::TestCase
  include TestFileable

  def setup
    super
    setup_photo_files

    @filename = 'test/photos/games.jpg'
  end

  def teardown
    super
    teardown_photo_files
  end

  test 'photo should belong to an article' do
    photo_without_article = Photo.new
    photo_without_article.valid?
    assert photo_without_article.errors[:article_id].any?,
      "photo should not be valid if does not belong to article"

    article = articles(:avena)
    photo_with_article = Photo.new(article_id: article.id)
    photo_with_article.valid?
    refute photo_with_article.errors[:article_id].any?,
      "photo should be valid if associated to an article"
  end

  test "photo attributes must not be empty" do
    photo = Photo.new
    assert photo.invalid?
    assert photo.errors[:filename].any?
  end

  test "cannot have two fichiers of same type" do
    FilesizeType.all.each do |filesize_type|
      photo = photos(:eaton_college)
      (1..2).each { photo.fichiers.new(filesize_type: filesize_type) }
      assert photo.invalid?, photo.errors.messages[:base].last
    end
  end

  test "should create a new photo with file" do
    photo = Photo.new do |p|
      p.article = articles(:avena)
      p.title = "My mom's photo"
      p.description = 'This is a beautiful new photo'
    end

    photo.load_photo_file = photo_data
    assert photo.save!, photo.errors.full_messages

    assert photo.fichiers.size > 0, 'Fichiers were not created'
    photo.fichiers.each do |fichier|
      assert IMAGE_DEST_FOLDER.opendir.any? { |file|
        file == fichier.filename },
             "Could not find the file (#{fichier.filename})" +
             "for photosize=#{fichier.filesize_type.name}"
    end
  end

  test "should assign new tags using tags_attributes=" do
    photo = photos(:eaton_college)

    photo.tags_attributes = { tags_attributes: 'tag1, tag2' }
    assert photo.save!,
      "The photo is not valid. Errors: #{photo.errors.full_messages}"

    tag1 = photo.tags.where(name: 'tag1').first
    assert photo.tags.where(name: 'tag1').any?, "should have created tag1"
    assert photo.tag_links.where(tag_id: tag1.id).any?,
      "should have created photo_tag for tag1"

    tag2 = photo.tags.where(name: 'tag2').first
    assert photo.tags.where(name: 'tag2').any?, "should have created tag2"
    assert photo.tag_links.where(tag_id: tag2.id).any?,
      "should have created tag_links for tag2"
  end

  test 'title should display nbsp; if empty' do
    photo = Photo.new(title: 'non-empty')
    assert photo.displayed_title == 'non-empty'

    photo = Photo.new(title: '')
    assert photo.displayed_title == '&nbsp;'

    photo = Photo.new(title: '  ')
    assert photo.displayed_title == '&nbsp;'

    photo = Photo.new(title: "\n")
    assert photo.displayed_title == '&nbsp;'
  end
end
