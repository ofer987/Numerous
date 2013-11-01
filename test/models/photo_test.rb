require 'test_helper'

IMAGE_SOURCE_FOLDER = Rails.root.join('test', 'resources', 'images')
IMAGE_DEST_FOLDER = Rails.root.join('test', 'assets', 'images', 'photos')

# For testing purposes
# The test photos should not be mixed in the real assets folder  
class Photo
  def photo_store
    IMAGE_DEST_FOLDER
  end
end

class PhotoTest < ActiveSupport::TestCase
  def setup
    # Recreate the destination  subdir
    FileUtils.mkdir_p(IMAGE_DEST_FOLDER)    
    
    @filename = 'test/photos/games.jpg'
  end
  
  def teardown
    # Remove the destination subdir
    FileUtils.rm_rf(IMAGE_DEST_FOLDER)

    # Recreate the destination  subdir
    FileUtils.mkdir_p(IMAGE_DEST_FOLDER)
    
    # Delete the temporary file
    @tmpfile.unlink unless @tmpfile == nil
  end
  
  test "photo attributes must not be empty" do
    photo = Photo.new
    assert photo.invalid?
    assert photo.errors[:filename].any?
  end

  test "title must not be nil and could not be blank" do
    photo = photos(:eaton_college)
    
    photo.title = nil
    assert photo.invalid?, 'should not be able to accept nil title'
    
    photo.title = ''
    assert photo.invalid?, 'should not be able to accept blank title'
    
    photo.title = 'long title'
    assert photo.valid?, 'should be able to accept a title with words'
  end
  
  test "filename" do
    ok = %w{ fred.jpg fred.png FRED.JPG FRED.Jpg }
    bad = %w{ fred.doc fred.gif/more fred.gif.more fred.gif fred.bmp }
    
    ok.each do |name|
      assert get_photo(name).valid?, "#{name} shouldn't be invalid"
    end
  
    bad.each do |name|
      assert get_photo(name).invalid?, "#{name} shouldn't be valid"
    end 
  end
  
  test "upload new photo" do
    games_photo = Photo.new()
    games_photo.title = 'Games Photo'
    games_photo.description = 'description 01'
    
    games_photo.load_photo_file = File.open(@filename)
    
    assert games_photo.valid?, "Cannot upload the photo #{@filename}"
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
  
  #test "must have original fichier" do
  #  new_photo = Photo.new
  #  new_photo.title = 'two flirty men'
  #  new_photo.description = 'wearing plaid shirts'
  #  new_photo.filename = 'uninspiring.jpg'
  #  
  #  # do not add any fichiers, least my photo not have an original ficihier!
  #  assert new_photo.valid?, "should not be able to save a photo that does not have an original fichier" 
  #end
  
  test "tags must be unique" do
    # This photo contains the tag "england"
    photo = photos(:eaton_college)
    england_tag = photo.tags.first
    
    # It should not be possible to add the same tag a second time
    photo.photo_tags.build { |same_tag| same_tag.tag_id = england_tag.id }
    
    assert photo.invalid?, "should not be possible for a photo to have the same tag twice"
  end

  test "photo description may be nil" do
    photo = Photo.new do |photo|
      photo.title = 'Foo'
      photo.filename = 'foo.jpg'
    end

    # Test photo with null description
    assert photo.valid?, "description should be able to be nil"
  end

  test "photo description could be non-nil" do
    photo = Photo.new do |photo|
      photo.title = 'Foo'
      photo.filename = 'foo.jpg'
      photo.description = 'non-empty description'
    end

    # Test photo with non-empty description
    assert photo.valid?, 'description should be able to be non-nil and non-empty'
  end
  
  test "should create a new photo with file" do
    photo = Photo.new do |photo|
      photo.title = "My mom's photo"      
      photo.description = 'This is a beautiful new photo'
    end
    
    photo.load_photo_file = photo_data
    assert photo.save, 'Failed to save a new photo with a file'
    
    assert photo.fichiers.size > 0, 'Fichiers were not created'
    photo.fichiers.each do |fichier|
      assert IMAGE_DEST_FOLDER.opendir.any? { |file| file == fichier.filename },
             "Could not find the file (#{fichier.filename}) for photosize=#{fichier.filesize_type.name}"
    end
  end
  
  def photo_data
    filename = 'DSC01740.JPG'
    @tmpfile = Tempfile.new(filename)
    File.open(@tmpfile.path, 'wb') do |dest_file|
      dest_file.write(IO.read(IMAGE_SOURCE_FOLDER.join(filename)))
    end
    ActionDispatch::Http::UploadedFile.new({
                                               filename: 'DSC01740.JPG',
                                               type: 'image/jpg',
                                               tempfile: @tmpfile,
                                               head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                           })
  end
  
  def get_photo(filename)
    # return some test photo fixture
    photo = photos(:eaton_college)
    photo.filename = filename
    
    return photo
  end
end
