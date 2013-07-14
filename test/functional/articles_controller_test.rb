require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @peru_stories_gazette = gazettes(:peru_stories)
    @cusco_trip_article = articles(:cusco_trip)
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
    new_article = Article.new
    new_article.gazette_id = @peru_stories_gazette.id
    new_article.content = 'new story'
    
    assert_difference('Article.count') do
      post :create, gazette_id: @peru_stories_gazette.id, article: new_article
    end
    
    assert_redirected_to gazette_article_path(@peru_stories_gazette.id, assigns(:article))
  end
  
  test "should get edit" do
    get :edit, gazette_id: @cusco_trip_article.gazette, id: @cusco_trip_article
    assert_response :success
  end
  
  test "should update article" do
    put :update, gazette_id: @peru_stories_gazette, id: @cusco_trip_article, article: { content: 'This is an awesome collection of stories' }
    assert_redirected_to gazette_article_path(@cusco_trip_article.gazette, assigns(:article))
  end
  
  test "should delete article" do
    delete :destroy, gazette_id: @cusco_trip_article.gazette, id: @cusco_trip_article
    assert_redirected_to gazette_articles_url(@cusco_trip_article.gazette)
    
    assert Article.where(id: @cusco_trip_article).count == 0, 'The cusco story article should have been deleted'
  end
end