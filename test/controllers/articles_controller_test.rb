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

    get :index, username: @edith.username, tags: tags_to_view.join(",")
    assert_response :success
  end

  test "should get index for all articles for user" do
    get :index, username: @edith.username
    assert_response :success
  end

  test "should get new for user" do
    get :new, username: @edith.username
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @cusco_trip_article.to_param, username: @edith.username
    assert_response :success
  end

  test 'should show article' do
    get :show, id: @cusco_trip_article.to_param, username: @edith.username
  end

  test "should create article" do
    article = {
      title: 'a new story with a title',
      content: 'new story',
      username: users(:edith).username
    }

    assert_difference('Article.count') do
      post :create, username: @edith.username, article: article
    end

    assert_redirected_to user_article_path(@edith.username, assigns(:article))
  end

  test "should update article" do
    new_content = 'This is an awesome story'

    put :update, username: @edith.username, format: :js, id: @cusco_trip_article,
      article: { content: new_content }
    assert_response :success
    assert_equal(
      "<p>#{new_content}</p>\n",
      assigns(:article).content,
      "The article's content should have been updated")
  end

  test "should fail to update article" do
    put :update, username: @edith.username, id: @cusco_trip_article,
      article: { content: nil }
    assert_response :success
    refute assigns(:article).valid?,
      "The article should not have been updated"
  end

  test "should delete article" do
    assert_difference('Article.count', -1) do
      delete :destroy, username: @edith.username, id: @cusco_trip_article.to_param
    end
    assert_redirected_to user_articles_url(@edith)
  end

  test 'should create article for user and assign it tags' do
    article = {
      username: @edith.username,
      title: 'new article',
      content: 'Article with tags',
      tags_attributes: 'england, quebec'
    }

    assert_difference('Article.count', 1) do
      post :create, username: @edith.username, format: :js, article: article
    end

    assert assigns(:article).tags.count == 2,
      'the two tags were not added to the article'
  end
end
