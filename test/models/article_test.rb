require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @valid_article = Article.new do |article|
      article.title = "Interesting Story"
      article.sub_title = "You Should Read This!"
      article.content = "Lots of interesting things to read here."
      article.published_at = DateTime.now
    end
  end
  
  test "should be able to modify an article's published_at date" do
    new_article = Article.new(published_at: DateTime.new(2012, 5, 12).getutc)
    
    assert new_article.save, "should be able to modify an article's published_at datetime"
    assert new_article.published_at.getutc == DateTime.new(2012, 5, 12).getutc, "the article cannot save its selected datetime"
  end

  test "article's default time published_at is now" do
    now_expected = DateTime.now.getutc
    new_article = Article.new

    assert new_article.published_at.getutc.year == now_expected.year &&
               new_article.published_at.getutc.month == now_expected.month &&
               new_article.published_at.getutc.day == now_expected.day

    assert new_article.valid?
  end
  
  test 'should save article' do
    assert @valid_article.save
  end
end
