require 'test_helper'
require 'test_fileable'

class PhotosControllerTest < ActionController::TestCase
  include TestFileable
  
  setup do
    setup_photo_files
    
    @photo = photos(:eaton_college)  
    @all_photo_tags_attributes = Hash.new
    Tag.all.each_with_index do |tag, index|
      @all_photo_tags_attributes["#{index}"] = { id: tag.id.to_s, is_selected: "0" }
    end
    
    @eaton_college_update = {
      title: 'Lorem Ipsum Photo',
      description: 'Description for Lorem Ipsum',
      tags_attributes: @all_photo_tags_attributes
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
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, photo: {
          description: @new_photo[:description],
          load_photo_file: self.photo_data,
          title: @new_photo[:title]
      }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should show photo" do
    get :show, id: @photo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @photo.to_param
    assert_response :success
  end

  test "should update photo" do
    put :update, id: @photo.to_param, photo: @eaton_college_update
    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should destroy photo" do
    # Setup the files for this photo in the assets dir
    @package = photos(:package)
    copy_fichier_files(@package)

    # Before delete the photos we need to know the fichiers that
    # have been destroyed as well
    
    assert_difference('Photo.count', -1) do
      delete :destroy, id: @package.to_param
    end
    
    # Are all the files of the fichiers deleted?
    #@package.fichiers.each do |fichier|
    #  assert !File.exist?("#{photos_dir}#{fichier.filename}"), "The file #{fichier.filename} was not deleted!"
    #end

    assert_redirected_to photos_path
  end
  
  test "should add a tag to a photo" do
    package_photo = photos(:package)
    
    # Add the tag "mail"
    tag = tags(:mail)
    params = 
      { 
        id: package_photo.id,
        photo_tags_attributes: @all_photo_tags_attributes
      }
      
    # the photo should have these expected tags after the update
    expected_tags = []
    expected_tags << tag
    package_photo.tags.each do |existing_tag|
      expected_tags << existing_tag
    end
    params[:photo_tags_attributes].each do |index, tag_attributes|
      tag_attributes[:is_selected] = "1" if expected_tags.any? { |tag| tag.id == tag_attributes[:id].to_i } 
    end
    
    # update the photo: add the new tag
    put :update, id: package_photo.id, photo: params
    
    assert_redirected_to photo_path(assigns(:photo)) 
    assert_equal expected_tags.count, package_photo.photo_tags.count, "The new tag was not added"
    
    # Does the photo have all the expected_tags?
    expected_tags.each do |tag|
      assert package_photo.photo_tags.any? { |verify_photo_tag| verify_photo_tag.tag_id == tag.id }, "The photo is missing the tag #{tag.name}"
    end
  end
  
  test "should remove a tag from a photo" do
    package_photo = photos(:package)
    params = {
      id: package_photo.id,
      photo_tags_attributes: @all_photo_tags_attributes
    }
    
    # These are the expected tags post-update
    expected_tags = []
    
    # Remove the first tag
    package_photo.tags.to_a[1..-1].each do |existing_tag|
      expected_tags << existing_tag
    end
    params[:photo_tags_attributes].each do |index, photo_tag_attributes|
      photo_tag_attributes[:is_selected] = "1" if expected_tags.any? { |tag| tag.id == photo_tag_attributes[:id].to_i } 
    end
    
    # update the photo: remove the first tag
    put :update, id: package_photo.id, photo: params
    
    assert_redirected_to photo_path(assigns(:photo))
    
    assert_equal expected_tags.count, package_photo.photo_tags.count, "The tag was not removed"
    
    # Check that the photo does not have any extraneous tags
    package_photo.photo_tags.each do |actual_photo_tag|
      assert expected_tags.any? { |expected_tag| expected_tag.id == actual_photo_tag.tag_id }, "The photo did not delete the tag #{actual_photo_tag.tag.name}"
    end
  end
  
  test "should add a newly created tag to a photo" do
    photo = photos(:no_tags)
    
    # This photo has two new tags called "new tag", and "second_tag"
    params = {
      id: photo.to_param,
      photo_tags_attributes: @all_photo_tags_attributes,
      tags_attributes: 'tag1, tag2'
    }
    
    put :update, id: photo.id, photo: params
    
    assert_equal photo.photo_tags.count, 2, "The two new tags were not created. Errors: #{assigns(:photo).errors.full_messages}"
  end
  
  # Set up the files for the photo
  # By copying them from the test dir to the assets dir
  def copy_fichier_files(photo)
    photo.fichiers.each do |fichier|
      puts `cp #{photos_test_dir}#{fichier.filename} #{photos_dir}`
    end
  end
end
