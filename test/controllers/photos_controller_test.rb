require 'test_helper'
require 'test_fileable'

class PhotosControllerTest < ActionController::TestCase
  include TestFileable

  setup do
    setup_photo_files

    @photo = photos(:eaton_college)
    @article = @photo.article

    @eaton_college_update = {
      title: 'Lorem Ipsum Photo',
      description: 'Description for Lorem Ipsum',
    }

    @new_photo = {
        description: 'This is a beautiful new photo',
        title: "My mom's photo"
    }
  end

  teardown do
    teardown_photo_files
  end

  test "should get index" do
    get :index, article_id: @article
    assert_response :success
  end

  test "should get new" do
    get :new, article_id: @article
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, article_id: @article.id, photo: {
          description: @new_photo[:description],
          load_photo_file: self.photo_data,
          title: @new_photo[:title]
      }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should show photo" do
    get :show, article_id: @photo.article, id: @photo.to_param
    assert_response :success
  end

  test "should show photo again (using an AJAX call)" do
    get :show, format: :js, id: @photo.to_param, article_id: @photo.article_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @photo.to_param, article_id: @photo.article_id
    assert_response :success
  end

  test "should update photo" do
    put :update, format: :js, id: @photo.to_param, article_id: @photo.article_id,
      photo: @eaton_college_update
    assert assigns(:photo).title == @eaton_college_update[:title]
  end

  test "should destroy photo" do
    # Setup the files for this photo in the assets dir
    @package = photos(:package)
    copy_fichier_files(@package)

    # Before delete the photos we need to know the fichiers that
    # have been destroyed as well

    assert_difference('Photo.count', -1) do
      delete :destroy, id: @package.to_param, article_id: @photo.article_id
    end

    # Are all the files of the fichiers deleted?
    #@package.fichiers.each do |fichier|
    #  assert !File.exist?("#{photos_dir}#{fichier.filename}"), "The file #{fichier.filename} was not deleted!"
    #end

    assert_redirected_to photos_path
  end

  # Set up the files for the photo
  # By copying them from the test dir to the assets dir
  def copy_fichier_files(photo)
    photo.fichiers.each do |fichier|
      puts `cp #{photos_test_dir}#{fichier.filename} #{photos_dir}`
    end
  end
end
