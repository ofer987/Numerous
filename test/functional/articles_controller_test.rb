require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @peru_stories_gazette = gazettes(:peru_stories)
    @cusco_trip_article = articles(:cusco_trip)
    
    @all_photos_attributes = Hash.new
    Photo.all.each_with_index do |photo, index|
      @all_photos_attributes["#{index}"] = { is_selected: "0", id: "#{photo.id}" }
    end
  end

  test "should get index" do
    get :index, gazette_id: @peru_stories_gazette
    assert_response :success
  end
  
  test "should get new" do
    get :new, gazette_id: @peru_stories_gazette
    assert_response :success
  end

  test "should create article" do
    new_article = {
      gazette_id: @peru_stories_gazette.id,
      content: 'new story',
      photos_attributes: @all_photos_attributes
    }
    new_article[:photos_attributes].each do |index, article_photo|
      article_photo[:is_selected] = "1" if article_photo[:id].to_i == photos(:eaton_college).id || article_photo[:id].to_i == photos(:nobody_commented).id
    end
    
    pre_article_photos_count = ArticlePhoto.count
    assert_difference('Article.count') do
      post :create, gazette_id: @peru_stories_gazette.id, article: new_article, is_convert_to_html: false
    end
    post_article_photos_count = ArticlePhoto.count
    
    assert_equal pre_article_photos_count + 2, post_article_photos_count, "Did not add the two photos to the new article" 
    assert_redirected_to gazette_article_path(@peru_stories_gazette.id, assigns(:article))
  end
  
  test "should get edit" do
    get :edit, gazette_id: @cusco_trip_article.gazette, id: @cusco_trip_article
    assert_response :success
  end
  
  test "should update article" do
    old_content = @cusco_trip_article.content
    new_content = 'This is an awesome story'
    
    put :update, gazette_id: @peru_stories_gazette, id: @cusco_trip_article, article: { content: new_content }
    assert_redirected_to gazette_article_path(@cusco_trip_article.gazette, assigns(:article))
    assert_equal new_content, assigns(:article).content, "The article's content should have been updated"
  end
  
  test "should delete article" do
    delete :destroy, gazette_id: @cusco_trip_article.gazette, id: @cusco_trip_article
    assert_redirected_to gazette_articles_url(@cusco_trip_article.gazette)
    
    assert Article.where(id: @cusco_trip_article).count == 0, 'The cusco story article should have been deleted'
  end
  
  test "should be able to modify an article's created_at date" do
    modified_date = DateTime.new(2010, 5, 12)
    
    @cusco_trip_article.created_at = modified_date
    
    post :update, gazette_id: @cusco_trip_article.gazette_id, id: @cusco_trip_article, article: { created_at: modified_date }
    assert assigns(:article).created_at == modified_date, "The article should be able to modify its created_at datetime"
  end
  
  test "should add a photo to an article" do
    article = articles(:cusco_trip)
    
    # Add the photo package
    photo = photos(:package)
    params = 
      { 
        id: article.id,
        gazette_id: article.gazette_id,
        photos_attributes: @all_photos_attributes
      }
    params[:photos_attributes].each do |key, value|
      value[:is_selected] = "1" if value[:id].to_i == photo.id
    end
      
    # the photo should have these expected tags after the update, including its current photos
    expected_photos = []
    expected_photos << photo
    
    article.photos.each do |existing_photo|
      expected_photos << existing_photo
      params[:photos_attributes].each do |key, value|
        value[:is_selected] = "1" if value[:id].to_i == existing_photo.id
      end
    end
    
    # update the article: add the new photo
    put :update, article: params, id: article.id, gazette_id: article.gazette_id, is_convert_to_html: false
    assert_redirected_to gazette_article_path(article.gazette_id, assigns(:article)) 
    assert_equal expected_photos.count, article.article_photos.count, "The new photo was not added"
    
    # Does the article have all the expected_photos?
    expected_photos.each do |photo|
      assert article.article_photos.any? { |verify_article_photo| verify_article_photo.photo_id == photo.id }, "The article is missing the photo #{photo.title}"
    end
  end
  
  test "should remove a photo from an article" do
    # This article should have at least two photos
    article = articles(:cusco_trip)
    params = {
      gazette_id: article.gazette_id,
      id: article.id,
      photos_attributes: @all_photos_attributes
    }
    
    # These are the expected photos post-update
    expected_photos = []
    
    # Remove the first photo
    article.photos[1..-1].each do |existing_photo|
      expected_photos << existing_photo
      params[:photos_attributes].each do |key, value|
        value[:is_selected] = "1" if value[:id].to_i == existing_photo.id
      end
    end
    
    # update the article: it should remove the first photo
    put :update, article: params, gazette_id: article.gazette_id, id: article.id, is_convert_to_html: false
    assert_redirected_to gazette_article_path(article.gazette_id, assigns(:article))
    assert_equal expected_photos.count, assigns(:article).photos.count, "The photo was not removed"
    
    # Check that the article does not have any extraneous photos
    article.article_photos.each do |actual_article_photo|
      assert expected_photos.any? { |expected_photo| expected_photo.id == actual_article_photo.photo_id }, "The article did not delete the photo #{actual_article_photo.photo.title}"
    end
  end
end