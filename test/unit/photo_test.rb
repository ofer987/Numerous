require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  setup do
    @filename = 'test/images/games.jpg'
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
  
  def get_photo(filename)
    # return some test photo fixture
    photo = photos(:eaton_college)
    photo.filename = filename
    
    return photo
  end
end
