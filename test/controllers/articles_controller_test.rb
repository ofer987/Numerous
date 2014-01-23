require 'test_helper'
require 'test_fileable'

class ArticlesControllerTest < ActionController::TestCase
  include TestFileable

  setup do
    @cusco_trip_article = articles(:cusco_trip)
    
    @all_article_photos_attributes = Hash.new
    Photo.all.each_with_index do |photo, index|
      @all_article_photos_attributes["#{index}"] = 
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
    get :edit, id: @cusco_trip_article.to_param
    assert_response :success
  end

  test "should create article" do
    article = {
      content: 'new story',
      published_at: DateTime.now
    }
    
    assert_difference('Article.count') do
      post :create, format: :js, article: article
    end
    
    assert_redirected_to article_path(assigns(:article))
  end

  test "should create article and add two photos" do
    new_article = {
      content: 'new story',
      article_photos_attributes: @all_article_photos_attributes
    }
    new_article[:article_photos_attributes].each do |index, article_photo|
      article_photo[:is_selected] = "1" if article_photo[:id].to_i == photos(:eaton_college).id || article_photo[:id].to_i == photos(:nobody_commented).id
    end
    
    pre_article_photos_count = ArticlePhoto.count
    assert_difference('Article.count') do
      post :create, article: new_article, is_convert_to_html: false
    end
    post_article_photos_count = ArticlePhoto.count
    
    assert_equal(
      pre_article_photos_count + 2, 
      post_article_photos_count, 
      "Did not add the two photos to the new article")
    assert_redirected_to article_path(assigns(:article))
  end
  
  test "should update article" do
    new_content = 'This is an awesome story'
    
    put :update, format: :js, id: @cusco_trip_article, 
      article: { content: new_content }
    assert_response :success
    assert_equal(
      "<p>#{new_content}</p>", 
      assigns(:article).content, 
      "The article's content should have been updated")
  end

  test "should fail to update article" do
    put :update, format: :js, id: @cusco_trip_article, 
      article: { published_at: nil }
    assert_response :success
    refute assigns(:article).valid?,
      "The article should not have been updated"
  end
  
  test "should delete article" do
    assert_difference('Article.count', -1) do
      delete :destroy, id: @cusco_trip_article.to_param
    end
    assert_redirected_to articles_url
  end
  
  test "should be able to modify an article's published_at date" do
    modified_date = DateTime.new(2010, 5, 12)
    
    @cusco_trip_article.published_at = modified_date
    
    post :update, format: :js, id: @cusco_trip_article, article: { published_at: modified_date }
    assert assigns(:article).published_at == modified_date, 
      "The article should be able to modify its published_at datetime"
  end
  
  test "should add a photo to an article" do
    article = articles(:cusco_trip)
    
    # Add the photo package
    photo = photos(:package)
    params = 
      { 
        id: article.id,
        article_photos_attributes: @all_article_photos_attributes
      }
    params[:article_photos_attributes].each do |key, value|
      value[:is_selected] = "1" if value[:id].to_i == photo.id
    end
      
    # the photo should have these expected tags after the update, including its current photos
    expected_photos = []
    expected_photos << photo
    
    article.photos.each do |existing_photo|
      expected_photos << existing_photo
      params[:article_photos_attributes].each do |key, value|
        value[:is_selected] = "1" if value[:id].to_i == existing_photo.id
      end
    end
    
    # update the article: add the new photo
    put :update, format: :js, article: params, id: article.id, is_convert_to_html: false
    assert_equal( 
      expected_photos.count, 
      article.article_photos.count, 
      "The new photo was not added. Errors: #{article.errors.full_messages}")
    
    # Does the article have all the expected_photos?
    expected_photos.each do |p|
      assert article.article_photos.any? { |verify_article_photo| 
        verify_article_photo.photo_id == p.id 
      }, "The article is missing the photo #{p.title}"
    end
  end
  
  test "should post new photo to existing article" do
    existing_article = articles(:cusco_trip)
    
    assert_difference('Photo.count', 1) do
      post :create_photo, 
        format: :js, 
        article_id: existing_article.id, 
        photo: { load_photo_file: self.photo_data } 
    end
    assert_response :success
  end

  test 'should create article and assign it tags' do
    article = {
      title: 'new article',
      content: 'Article with tags',
      tags_attributes: 'england, quebec'
    }
    
    assert_difference('Article.count', 1) do
      post :create, format: :js, article: article
    end
    assert assigns(:article).tags.count == 2, 
      'the two tags were not added to the article'
  end
end
