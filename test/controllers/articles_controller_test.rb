require 'test_helper'
require 'test_fileable'

class ArticlesControllerTest < ActionController::TestCase
  include TestFileable

  setup do
    @edith = users(:edith)
    @cusco_trip_article = articles(:cusco_trip)

    @all_article_photos_attributes = Hash.new
    Photo.all.each_with_index do |photo, index|
      @all_article_photos_attributes["#{index}"] =
        { is_selected: "0", id: "#{photo.id}" }
    end
  end

  test "should get index for all articles that belong to a tag for user" do
    tags_to_view = [ tags(:toronto), tags(:montreal) ]

    get :index, user_id: @edith, tags: tags_to_view.join(",")
    assert_response :success
  end

  test "should get index for all articles for user" do
    get :index, user_id: @edith
    assert_response :success
  end

  test "should get new for user" do
    get :new, user_id: @edith
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @cusco_trip_article.to_param, user_id: @edith
    assert_response :success
  end

  test "should create article" do
    article = {
      content: 'new story',
      published_at: DateTime.now,
      user_id: users(:edith).to_param
    }

    assert_difference('Article.count') do
      post :create, user_id: @edith, format: :js, article: article
    end

    assert_redirected_to user_article_path(@edith, assigns(:article))
  end

  test "should update article" do
    new_content = 'This is an awesome story'

    put :update, user_id: @edith, format: :js, id: @cusco_trip_article,
      article: { content: new_content }
    assert_response :success
    assert_equal(
      "<p>#{new_content}</p>\n",
      assigns(:article).content,
      "The article's content should have been updated")
  end

  test "should fail to update article" do
    put :update, user_id: @edith, format: :js, id: @cusco_trip_article,
      article: { published_at: nil }
    assert_response :success
    refute assigns(:article).valid?,
      "The article should not have been updated"
  end

  test "should delete article" do
    assert_difference('Article.count', -1) do
      delete :destroy, user_id: @edith, id: @cusco_trip_article.to_param
    end
    assert_redirected_to user_articles_url(@edith)
  end

  test "should be able to modify a article's published_at date" do
    modified_date = DateTime.new(2010, 5, 12)

    @cusco_trip_article.published_at = modified_date

    post :update, user_id: @edith, format: :js, id: @cusco_trip_article, article: { published_at: modified_date }
    assert assigns(:article).published_at == modified_date,
      "The article should be able to modify its published_at datetime"
  end

  test 'should create article for user and assign it tags' do
    article = {
      user_id: @edith.to_param,
      title: 'new article',
      content: 'Article with tags',
      tags_attributes: 'england, quebec'
    }

    assert_difference('Article.count', 1) do
      post :create, user_id: @edith, format: :js, article: article
    end

    assert assigns(:article).tags.count == 2,
      'the two tags were not added to the article'
  end
end
