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
  
  test "photo can have no comments" do
    photo = photos(:nobody_commented)
    assert photo.comments.count == 0
  end
  
  test "tags must be unique" do
    # This photo contains the tag "england"
    photo = photos(:eaton_college)
    england_tag = photo.tags.first
    
    # It should not be possible to add the same tag a second time
    photo.photo_tags.build { |same_tag| same_tag.tag_id = england_tag.id }
    
    assert photo.invalid?, "should not be possible for a photo to have the same tag twice"
  end

  test "should create a new photo with file" do
    photo = Photo.new do |photo|
      photo.title = "My mom's photo"      
      photo.description = 'This is a beautiful new photo'
    end
    
    photo.load_photo_file = photo_data
    photo.save
    
    assert photo.fichiers.size > 0, 'Fichiers were not created'
    photo.fichiers.each do |fichier|
      assert IMAGE_DEST_FOLDER.opendir.any? { |file| file == fichier.filename },
             "Could not find the file (#{fichier.filename}) for photosize=#{fichier.filesize_type.name}"
    end
  end
end
