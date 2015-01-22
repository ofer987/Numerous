require 'test_helper'
require 'test_fileable'

class BilletsControllerTest < ActionController::TestCase
  include TestFileable

  setup do
    @cusco_trip_billet = billets(:cusco_trip)

    @all_billet_photos_attributes = Hash.new
    Photo.all.each_with_index do |photo, index|
      @all_billet_photos_attributes["#{index}"] =
        { is_selected: "0", id: "#{photo.id}" }
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @cusco_trip_billet.to_param
    assert_response :success
  end

  test "should create billet" do
    billet = {
      content: 'new story',
      published_at: DateTime.now
    }

    assert_difference('Billet.count') do
      post :create, format: :js, billet: billet
    end

    assert_redirected_to billet_path(assigns(:billet))
  end

  test "should create billet and add two photos" do
    new_billet = {
      content: 'new story',
      billet_photos_attributes: @all_billet_photos_attributes
    }
    new_billet[:billet_photos_attributes].each do |index, billet_photo|
      billet_photo[:is_selected] = "1" if billet_photo[:id].to_i == photos(:eaton_college).id || billet_photo[:id].to_i == photos(:nobody_commented).id
    end

    pre_billet_photos_count = BilletPhoto.count
    assert_difference('Billet.count') do
      post :create, billet: new_billet, is_convert_to_html: false
    end
    post_billet_photos_count = BilletPhoto.count

    assert_equal(
      pre_billet_photos_count + 2,
      post_billet_photos_count,
      "Did not add the two photos to the new billet")
    assert_redirected_to billet_path(assigns(:billet))
  end

  test "should update billet" do
    new_content = 'This is an awesome story'

    put :update, format: :js, id: @cusco_trip_billet,
      billet: { content: new_content }
    assert_response :success
    assert_equal(
      "<p>#{new_content}</p>",
      assigns(:billet).content,
      "The billet's content should have been updated")
  end

  test "should fail to update billet" do
    put :update, format: :js, id: @cusco_trip_billet,
      billet: { published_at: nil }
    assert_response :success
    refute assigns(:billet).valid?,
      "The billet should not have been updated"
  end

  test "should delete billet" do
    assert_difference('Billet.count', -1) do
      delete :destroy, id: @cusco_trip_billet.to_param
    end
    assert_redirected_to billets_url
  end

  test "should be able to modify an billet's published_at date" do
    modified_date = DateTime.new(2010, 5, 12)

    @cusco_trip_billet.published_at = modified_date

    post :update, format: :js, id: @cusco_trip_billet, billet: { published_at: modified_date }
    assert assigns(:billet).published_at == modified_date,
      "The billet should be able to modify its published_at datetime"
  end

  test "should add a photo to an billet" do
    billet = billets(:cusco_trip)

    # Add the photo package
    photo = photos(:package)
    params =
      {
        id: billet.id,
        billet_photos_attributes: @all_billet_photos_attributes
      }
    params[:billet_photos_attributes].each do |key, value|
      value[:is_selected] = "1" if value[:id].to_i == photo.id
    end

    # the photo should have these expected tags after the update, including its current photos
    expected_photos = []
    expected_photos << photo

    billet.photos.each do |existing_photo|
      expected_photos << existing_photo
      params[:billet_photos_attributes].each do |key, value|
        value[:is_selected] = "1" if value[:id].to_i == existing_photo.id
      end
    end

    # update the billet: add the new photo
    put :update, format: :js, billet: params, id: billet.id, is_convert_to_html: false
    assert_equal(
      expected_photos.count,
      billet.billet_photos.count,
      "The new photo was not added. Errors: #{billet.errors.full_messages}")

    # Does the billet have all the expected_photos?
    expected_photos.each do |p|
      assert billet.billet_photos.any? { |verify_billet_photo|
        verify_billet_photo.photo_id == p.id
      }, "The billet is missing the photo #{p.title}"
    end
  end

  test "should post new photo to existing billet" do
    existing_billet = billets(:cusco_trip)

    assert_difference('Photo.count', 1) do
      post :create_photo,
        format: :js,
        billet_id: existing_billet.id,
        photo: { load_photo_file: self.photo_data }
    end
    assert_response :success
  end

  test 'should create billet and assign it tags' do
    billet = {
      title: 'new billet',
      content: 'Billet with tags',
      tags_attributes: 'england, quebec'
    }

    assert_difference('Billet.count', 1) do
      post :create, format: :js, billet: billet
    end
    assert assigns(:billet).tags.count == 2,
      'the two tags were not added to the billet'
  end
end
