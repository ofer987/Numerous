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
  
  test "should create a new photo with file" do
    photo = Photo.new do |p|
      p.title = "My mom's photo"      
      p.description = 'This is a beautiful new photo'
    end
    
    photo.load_photo_file = photo_data
    photo.save
    
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
end
